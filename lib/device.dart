import 'package:anicare/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  const BluetoothDeviceListEntry(
      {Key? key, required this.onTap, required this.device})
      : super(key: key);
  final VoidCallback onTap;
  final BluetoothDevice? device;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(Icons.devices),
          title: Text(
            device!.name ?? "Unknown Device",
            style: const TextStyle(color: AppColors.lightBlue),
          ),
          subtitle: Text(device!.address.toString()),
          trailing: InkWell(
            onTap: onTap,
            child: Card(
              color: AppColors.blue,
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 5,
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Connect',
                      style: TextStyle(color: Color(0xffF2F2F2)),
                    )),
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xffa1a1a1),
        )
      ],
    );
  }
}
