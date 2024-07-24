import 'package:course/db_matkul.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allData = [];

  bool isLoading = true;
  void refreshData() async {
    final data = await SQLMatkul.getData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  final TextEditingController nama = TextEditingController();
  final TextEditingController kode = TextEditingController();
  final TextEditingController jadwal = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData = allData.firstWhere((element) => element['id'] == id);
      nama.text = existingData['nama_mata_kuliah'];
      kode.text = existingData['kode_mata_kuliah'];
      jadwal.text = existingData['jadwal_kuliah'];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: nama,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nama Mata Kuliah",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: kode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Kode Mata Kuliah",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: jadwal,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Jadwal Kuliah",
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await addData();
                  }
                  if (id != null) {
                    await updateData(id);
                  }

                  nama.text = "";
                  kode.text = "";
                  jadwal.text = "";
                  Navigator.of(context).pop();
                  print("Data Added");
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add Data" : "Update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addData() async {
    await SQLMatkul.createData(nama.text, kode.text, jadwal.text);
    refreshData();
  }

  Future<void> updateData(int id) async {
    await SQLMatkul.updateData(id, nama.text, kode.text, jadwal.text);
    refreshData();
  }

  void deleteData(int id) async {
    await SQLMatkul.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data Deleted"),
    ));
    refreshData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text("Course Remainder"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : allData.isEmpty
              ? Center(
                  child: Text(
                    "Empty",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.all(15),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allData[index]['nama_mata_kuliah'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            allData[index]['kode_mata_kuliah'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        allData[index]['jadwal_kuliah'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showBottomSheet(allData[index]['id']);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteData(allData[index]['id']);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
