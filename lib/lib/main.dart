Audit deparp - Roshan
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() => runApp(MithilaAuditApp());

class MithilaAuditApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internal Audit Checklist',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AuditHomePage(),
    );
  }
}

class AuditHomePage extends StatefulWidget {
  @override
  _AuditHomePageState createState() => _AuditHomePageState();
}

class _AuditHomePageState extends State<AuditHomePage> {
  // १. शाखाको विवरण
  final Map<String, TextEditingController> branchControllers = {
    "शाखा कार्यालयको नाम": TextEditingController(),
    "कार्यालयको ठेगाना": TextEditingController(),
    "लेखापरिक्षण गरिएको अवधि": TextEditingController(),
    "लेखापरिक्षणमा लागेको समय": TextEditingController(),
    "शाखामा कार्यरत कर्मचारी": TextEditingController(),
    "केन्द्र संख्या": TextEditingController(),
    "सदस्य संख्या": TextEditingController(),
    "ऋणी सदस्य संख्या": TextEditingController(),
    "लगानीमा रहीरहेको रकम": TextEditingController(),
    "बचत परिचालन": TextEditingController(),
    "भाखा नाघेको कर्जा": TextEditingController(),
    "भाखा नाघेको कर्जा प्रतिशत": TextEditingController(),
    "सुक्ष्म निगरानीमा रहेको कर्जा": TextEditingController(),
  };

  // २. नगद विवरण
  final List<int> noteValues = [1000, 500, 100, 50, 20, 10, 5, 2, 1];
  Map<int, int> noteCounts = {};
  double totalCashAmount = 0.0;

  // ३. चेकलिस्ट बुँदाहरू
  final List<String> checklistTasks = [
    "१. हाजिर रजिष्टर", "२. फिल्ड रजिष्ट्रर", "३. विदा अभिलेख रजिष्टर",
    "४. कर्मचारी विदा निवेदन फाईल", "५. Day Book", "६. नगद रजिष्टर (Cash Register)",
    "७. नगद हस्तान्तरण रजिस्टर", "८. चेक बुक रजिष्टर", "९. ढुकुटी साँचो जिम्मा रजिष्टर",
    "१०. तमसुक दर्ता रजिष्टर", "११. कर्जा उप-समिति रजिष्टर", "१२. सदुपयोगीता जाँच रजिष्टर",
    "१३. ताकेता रजिस्टर", "१४. धितो कर्जा रजिस्टर", "१५. दर्ता / चलानी रजिष्टर",
    "१६. दर्ता / चलानी फाइल", "१७. परिपत्र फाइल", "१८. कर्मचारी मासिक बैठक रजिष्टर",
    "१९. कर्मचारी व्यक्तिगत लक्ष्य प्रगति फाईल", "२०. मसलन्द रेकर्ड रजिष्टर",
    "२१. स्थीर सम्पत्ती रजिष्टर", "२२. न्युन लागत सम्पत्ती रजिष्टर",
    "२३. आगन्तुक रजिष्टर (Guest Register)", "२४. Area/HO निरिक्षण प्रतिवेदन फाईल",
    "२५. केन्द्र बैठक निरिक्षण फाईल", "२६. नगदी रसिद ठेली बुझेको भरपाई",
    "२७. गुनासो पेटिका तथा रजिस्टर", "२८. पासबुक वितरण रजिष्टर",
    "२९. पासबुक भिडान रजिस्टर (Quarterly)", "३०. सदस्य दर्ता रजिष्टर",
    "३१. सदस्यता त्याग रजिष्टर", "३२. अन्य फाइलहरु"
  ];
  Map<int, bool> taskChecked = {};

  @override
  void initState() {
    super.initState();
    for (var n in noteValues) noteCounts[n] = 0;
    for (int i = 0; i < checklistTasks.length; i++) taskChecked[i] = false;
  }

  void refreshTotal() {
    double sum = 0;
    noteCounts.forEach((key, value) => sum += key * value);
    setState(() => totalCashAmount = sum);
  }

  // PDF रिपोर्ट बनाउने फङ्सन
  Future<void> createPdfReport() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Center(child: pw.Text("Mithila Laghubitta Bittiya Sanstha Ltd.", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)))),
          pw.Center(child: pw.Text("Internal Audit Checklist Report", style: pw.TextStyle(fontSize: 16))),
          pw.SizedBox(height: 20),
          pw.Text("1. Branch Details:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...branchControllers.entries.map((e) => pw.Bullet(text: "${e.key}: ${e.value.text}")),
          pw.SizedBox(height: 20),
          pw.Text("2. Cash Denomination:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text("Total Cash Found: Rs. $totalCashAmount"),
          pw.SizedBox(height: 20),
          pw.Text("3. Audit Checklist Status:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...checklistTasks.asMap().entries.map((e) => pw.Text("${e.value}: ${taskChecked[e.key]! ? "[OK]" : "[PENDING]"}")),
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Mithila Laghubitta Bittiya Sanstha Ltd.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Internal Audit Checklist", style: TextStyle(fontSize: 14)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // १. शाखाको विवरण
            SectionHeader(title: "१. शाखाको विवरण"),
            ...branchControllers.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(controller: e.value, decoration: InputDecoration(labelText: e.key, border: OutlineInputBorder())),
            )).toList(),

            // २. नगद विवरण
            SectionHeader(title: "२. नगद विवरण (Cash Denomination)"),
            ...noteValues.map((n) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text("रु. $n  x", style: TextStyle(fontSize: 16))),
                  Expanded(flex: 2, child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) { noteCounts[n] = int.tryParse(v) ?? 0; refreshTotal(); },
                    decoration: InputDecoration(hintText: "संख्या", border: OutlineInputBorder()),
                  )),
                  Expanded(flex: 3, child: Text(" = रु. ${n * (noteCounts[n] ?? 0)}", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            )).toList(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.all(15),
              color: Colors.green.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("कुल नगद मौज्दात:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("रु. $totalCashAmount", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                ],
              ),
            ),

            // ३. चेकलिस्ट
            SectionHeader(title: "३. विभिन्न रजिष्टरहरुको अवस्था (Checklist)"),
            ...checklistTasks.asMap().entries.map((e) => CheckboxListTile(
              title: Text(e.value),
              value: taskChecked[e.key],
              onChanged: (val) => setState(() => taskChecked[e.key] = val!),
            )).toList(),

            SizedBox(height: 30),
            
            // ४. बटनहरू
            ElevatedButton.icon(
              icon: Icon(Icons.picture_as_pdf, color: Colors.white),
              label: Text("Save & Download PDF", style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: createPdfReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// हेडर बनाउने सानो Widget
class SectionHeader extends StatelessWidget {
  final String title;
  SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
          Divider(thickness: 2),
        ],
      ),
    );
  }
}
