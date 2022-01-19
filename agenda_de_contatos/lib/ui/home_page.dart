import 'dart:io';

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:agenda_de_contatos/ui/contact_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> lContacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderza,
                )
              ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add, color: Colors.black,),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
          itemCount: lContacts.length,
          itemBuilder: (context, index){
          return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget> [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: lContacts[index].image != null ?
                    FileImage(File(lContacts[index].image)) :
                      AssetImage("images/person.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(lContacts[index].name ?? "",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(lContacts[index].email ?? "",
                      style: TextStyle(
                          fontSize: 18.0,
                      ),
                    ),
                    Text(lContacts[index].phone ?? "",
                      style: TextStyle(
                          fontSize: 18.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      });
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:  FlatButton(
                            onPressed: (){
                              launch("tel: ${lContacts[index].phone}");
                              Navigator.pop(context);
                            },
                            child: Text("Ligar", style: TextStyle(
                                color: Colors.redAccent, fontSize: 20.0
                            ),
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:  FlatButton(
                            onPressed: (){
                              Navigator.pop(context);
                              _showContactPage(contact: lContacts[index]);
                            },
                            child: Text("Editar", style: TextStyle(
                                color: Colors.redAccent, fontSize: 20.0
                            ),
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:  FlatButton(
                            onPressed: (){
                              setState(() {
                                helper.deleteContact(lContacts[index].id);
                                lContacts.removeAt(index);
                                Navigator.pop(context);
                              });
                            },
                            child: Text("Excluir", style: TextStyle(
                                color: Colors.redAccent, fontSize: 20.0
                            ),
                            )
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context)=>ContactPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        lContacts = list;
      });
    });
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        lContacts.sort((a,b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;

      case OrderOptions.orderza:
        lContacts.sort((a,b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}
