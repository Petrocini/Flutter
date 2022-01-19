import 'dart:io';

import 'package:agenda_de_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_nameController.text.isNotEmpty && _editedContact.name != null){
              if(_emailController.text.isNotEmpty && _editedContact.email != null){
                if(_phoneController.text.isNotEmpty && _editedContact.phone != null){
                  Navigator.pop(context, _editedContact);
                }else{
                  FocusScope.of(context).requestFocus(_phoneFocus);
                }
                }else{
                FocusScope.of(context).requestFocus(_emailFocus);
              }
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save, color: Colors.white,),
          backgroundColor: Colors.redAccent,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          child: Column(
            children: <Widget> [
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.image != null ?
                          FileImage(File(_editedContact.image)) :
                          AssetImage("images/person.png"),
                        fit: BoxFit.cover
                      )
                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editedContact.image = file.path;
                    });
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
                controller: _nameController,
                keyboardType: TextInputType.name,
                focusNode: _nameFocus,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "E-mail"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.email = text;
                },
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailFocus,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                focusNode: _phoneFocus,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações ?"),
          content: Text("Se sair as alterações serã perdidas."),
          actions: <Widget> [
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancelar")
            ),
            FlatButton(
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Sim"),
            )
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

}