import 'dart:html';
import 'dart:io';
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAll().then((contacts) {
      setState(() {
        this.contacts = contacts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: this.contacts.length,
        itemBuilder: _contactCard,
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    Contact contact = this.contacts[index];
    ImageProvider<dynamic> contactImg;
    if (contact.img == null ||
        contact.img.length == 0 ||
        !(File(contact.img).existsSync())) {
      contactImg = AssetImage("images/person.png");
    } else {
      contactImg = FileImage(File(contact.img));
    }

    return GestureDetector(
      onTap: () {
        _showContactPage(contact: contact);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: contactImg),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contact.name ?? "",
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Text(
                      contact.email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      contact.phone ?? "",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

void _showOptions(BuildContext context, int index){
  showModalBottonSheet(
    context: context,
    builder: (context){
      return BottomSheet(
        builder: context,){
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text("Ligar"),
                  )
              ],),
          )
        }
    }
    )
}

  void _showContactPage({Contact contact}) async {
    final editedContact = await Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => ContactPage(contact: contact)));
    if (editedContact != null) {
      if (contact == null)
        await helper.saveContact(editedContact);
      else
        await helper.updateContact(editedContact);

      _getAllContacts();
    }
  }
}