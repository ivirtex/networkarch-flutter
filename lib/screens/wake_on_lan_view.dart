// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_arch/models/wake_on_lan_model.dart';
import 'package:network_arch/services/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class WakeOnLanView extends StatefulWidget {
  const WakeOnLanView({Key? key}) : super(key: key);

  @override
  _WakeOnLanViewState createState() => _WakeOnLanViewState();
}

class _WakeOnLanViewState extends State<WakeOnLanView> {
  final ipv4TextFieldController = TextEditingController();

  final macTextFieldController = TextEditingController();

  bool areTextFieldsValid() {
    return ipv4TextFieldController.text.isNotEmpty &&
        macTextFieldController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wake on LAN'),
        iconTheme: Theme.of(context).iconTheme,
        textTheme: Theme.of(context).textTheme,
        actions: [
          TextButton(
            onPressed: !areTextFieldsValid()
                ? null
                : () {
                    context
                        .read<WakeOnLanModel>()
                        .wolResponses
                        .add(WolResponse('ipv4', ''));

                    print('added');
                  },
            child: Text(
              'Send',
              style: TextStyle(
                color: areTextFieldsValid() ? Colors.green : Colors.grey,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              controller: ipv4TextFieldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: 'IPv4 address',
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: macTextFieldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                labelText: 'MAC address',
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            StreamBuilder(
              initialData: null,
              stream: context.read<WakeOnLanModel>().getStream(),
              builder: (context, AsyncSnapshot<WolResponse?> snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: context.read<WakeOnLanModel>().wolResponses.length,
                  itemBuilder: (context, index) {
                    final WolResponse response =
                        context.read<WakeOnLanModel>().wolResponses[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: DataCard(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              StatusCard(text: 'Success', color: Colors.green),
                              Text(response.ipv4),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
