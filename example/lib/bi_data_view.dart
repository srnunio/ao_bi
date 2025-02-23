import 'package:ao_bi/bi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BIDataView extends StatefulWidget {
  final BIData data;

  const BIDataView(this.data);

  @override
  State<StatefulWidget> createState() => _BIDataViewState();
}

class _BIDataViewState extends State<BIDataView> {
  String getDate(DateTime? dateTime) {
    var dataFormatted = DateFormat("dd/MM/yyyy");
    return (dateTime != null) ? dataFormatted.format(dateTime) : "?";
  }

  Widget buildTile({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: SelectableText(value),
          ),
        )
      ],
    );
  }

  Widget bottomNavigationBar() {
    return SizedBox(
      height: 50.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.deepPurple,
          elevation: 0.0,
          child: const SizedBox(
            width: double.infinity,
            height: 50.0,
            child: Center(
                child: Text(
              "Confirmar",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(30.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: bottomNavigationBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "BIlhete De Identificação",
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.left,
                ),
              ),
              const Divider(),
              const SizedBox(height: 20.0),
              buildTile(
                  label: "Estado do documento",
                  value: data.isExpired() ? "Expirado" : "Válido"),
              const Divider(),
              buildTile(label: "BI", value: data.id ?? "..."),
              const Divider(),
              buildTile(label: "Nome", value: data.name ?? "..."),
              const Divider(),
              buildTile(
                  label: "Estado civil", value: data.maritalStatus ?? '...'),
              const Divider(),
              buildTile(label: "Genero", value: data.gender ?? '...'),
              const Divider(),
              buildTile(label: "Provincia", value: data.province ?? '...'),
              const Divider(),
              buildTile(
                  label: "Data de nascimento", value: getDate(data.birthdate)),
              const Divider(),
              buildTile(
                  label: "Data de emissão", value: getDate(data.dateOfIssue)),
              const Divider(),
              buildTile(
                  label: "Data de expiração",
                  value: getDate(data.expirationDate)),
            ],
          ),
        ),
      ),
    );
  }
}
