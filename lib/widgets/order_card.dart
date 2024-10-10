import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'image_grid.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ImageGrid(images: const ['', '', '', '', ''])),
              // Additional UI components like Order status, Total price, etc.
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: maincolor,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                          child: Text('Accepted',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total price:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' 700 Birr',
                          style: TextStyle(
                              color: maincolor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Payment:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' CBE',
                          style: TextStyle(
                              color: maincolor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              Text(
                '02:35 PM',
                style: TextStyle(
                    color: maincolor.withOpacity(0.4),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
