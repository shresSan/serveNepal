import 'package:flutter/material.dart';
import 'package:restaurant_freelance_job/core/Provider/priceList_provider.dart';
import 'file:///D:/RestaurantApp/restaurant_freelance_job/lib/viewModels/JobRoles.dart';

import '../services/auth.dart';

class PriceList extends StatefulWidget {
  final List<JobRoles> priceList;
  PriceList({this.priceList});

  @override
  _PriceListState createState() => _PriceListState();
}

class _PriceListState extends State<PriceList> {

  @override
  void initState() {
    PriceListProvider priceListProvider = new PriceListProvider();
    priceListProvider.loadPriceList(widget.priceList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Rate Per Hour"),
            backgroundColor: Colors.cyan),
        body: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Price(Per Hour)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          ],
          rows: widget.priceList
              .map(
                (role) => DataRow(
                cells: [
                  DataCell(
                     Text(role.name,
                         style: TextStyle(fontSize: 14)),
                  ),
                  DataCell(
                    Text("Rs." + role.pricePerHour.toString(),
                      style: TextStyle(fontSize: 14)),
                  ),
                ]),
          ).toList(),
        )
    );
  }
}