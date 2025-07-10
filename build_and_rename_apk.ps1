# Check if a project name is passed as an argument
if (-not $args[0]) {
    Write-Host "Error: Please provide a project name."
    exit 1
}

# Define the base path for your projects
Write-Host "Setting up project paths..."
$PROJECTS_PATH = "C:\flutter_dev\projects"
$PROJECT_NAME = $args[0]
Write-Host $PROJECT_NAME
$PROJECT_DIR = "$PROJECTS_PATH\$PROJECT_NAME"
Write-Host $PROJECT_DIR

# Check if the project directory exists
if (-not (Test-Path $PROJECT_DIR)) {
    Write-Host "Error: Project directory '$PROJECT_DIR' does not exist."
    exit 1
}

# Navigate to the project directory
Write-Host "Navigating to project directory..."
Set-Location -Path $PROJECT_DIR

# Extract the current version from pubspec.yaml
Write-Host "Extracting current version..."
$version_line = (Select-String -Pattern "^version: " pubspec.yaml).Line
$version_line = $version_line -replace "version: ", ""

# Separate version and build number
$version_parts = $version_line -split "\+"
$current_version = $version_parts[0]
$current_build_number = [int]$version_parts[1]

# Increment the build number
$new_build_number = $current_build_number + 1
Write-Host "Incremented build number to $new_build_number"

# Optionally increment the patch version
$version_tokens = $current_version -split "\."
$major_version = $version_tokens[0]
$minor_version = $version_tokens[1]
$patch_version = [int]$version_tokens[2] + 1

# Construct the new version string
$new_version = "$major_version.$minor_version.$patch_version"
$new_full_version = "$new_version+$new_build_number"
Write-Host "New version set to $new_full_version"

# Update the version in pubspec.yaml
Write-Host "Updating pubspec.yaml..."
(Get-Content pubspec.yaml) | ForEach-Object {
    if ($_ -match "^version: ") {
        "version: $new_full_version"
    } else {
        $_
    }
} | Set-Content pubspec_temp.yaml

Move-Item -Force pubspec_temp.yaml pubspec.yaml

Write-Host "Version updated successfully"

# Run flutter pub get and build the release APK
Write-Host "Running flutter pub get and building APK..."
flutter pub get
flutter build apk --release

# Locate the generated APK
$APK_DIR = "$PROJECT_DIR\build\app\outputs\flutter-apk"
$ORIGINAL_APK = "$APK_DIR\app-release.apk"

if (-not (Test-Path $ORIGINAL_APK)) {
    Write-Host "Error: APK file not found at '$ORIGINAL_APK'."
    exit 1
}

# Rename the APK file to include the project name and version
$NEW_APK_NAME = "${PROJECT_NAME}_${new_full_version}.apk"
$NEW_APK_PATH = "$APK_DIR\$NEW_APK_NAME"

Write-Host "Renaming APK to $NEW_APK_NAME..."
Rename-Item -Path $ORIGINAL_APK -NewName $NEW_APK_NAME

if (Test-Path $NEW_APK_PATH) {
    Write-Host "APK successfully renamed to '$NEW_APK_NAME'."
} else {
    Write-Host "Error: Failed to rename APK."
    exit 1
}

Write-Host "Build and renaming completed successfully for project: $PROJECT_NAME"
