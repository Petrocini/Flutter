import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Informações da tabela
final String TABELA = 'CONTACT';
final String ID_CNT = 'ID_CNT';
final String NAME_CNT = 'NAME_CNT';
final String EMAIL_CNT = 'EMAIL_CNT';
final String PHONE_CNT = 'PHONE_CNT';
final String IMAGE_CNT = 'IMAGE_CNT';

class ContactHelper {
  //Instancia
  static final ContactHelper _instance = ContactHelper.internal();

  //Construtor interno - internal
  factory ContactHelper() => _instance;

  //Chamar a instancia
  ContactHelper.internal();

  //Inicializando db
  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  //Future e await utilizados pois a função não retorna instantaneamente
  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contacts.db");

    return await openDatabase(
        path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $TABELA("
              "$ID_CNT INTEGER PRIMARY KEY, "
              "$NAME_CNT TEXT, "
              "$EMAIL_CNT TEXT, "
              "$PHONE_CNT TEXT, "
              "$IMAGE_CNT TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    //Cria a instancia do Database
    Database dbContact = await db;
    //Cria o insert na TABELA e passa o contato em forma de Map
    //Retorna o id do contato
    contact.id = await dbContact.insert(TABELA, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    //Cria a instancia do Database
    Database dbContact = await db;
    //Cria um map com a query para recuperar os contatos
    //Passa a tabela e os campos que deseja recuperar
    //Passa a chave primaria(ou filtro) que deseja recuperar - where
    //Passa o argumento pós =
    List<Map> listContact = await dbContact.query(TABELA,
        columns: [ID_CNT, NAME_CNT, EMAIL_CNT, PHONE_CNT, IMAGE_CNT],
        where: "$ID_CNT = ?",
        whereArgs: [id]
    );

    //Verificando se a query retornou algo
    if (listContact.length > 0) {
      return Contact.fromMap(listContact.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    //Cria a instancia do Database
    Database dbContact = await db;
    //Deletando o contato da tabela de acordo com a chave primaria (ID)
    return await dbContact.delete(TABELA,
        where: "$ID_CNT = ?",
        whereArgs: [id]
    );
  }

  Future<int> updateContact(Contact contact) async {
    //Cria a instancia do database
    Database dbContact = await db;
    //Dando update nos dados de acordo com a chave primaria (ID)
    return await dbContact.update(TABELA,
        contact.toMap(),
        where: "$ID_CNT = ?",
        whereArgs: [contact.id]
    );
  }

 Future<List> getAllContacts() async {
    //Cria a instancia do database
    Database dbContact = await db;
    //Criando Map para pegar todos os contatos
    List listMap = await dbContact.rawQuery("SELECT * FROM $TABELA");
    //Transformando cada Map em um contato para listar
    List<Contact> listContacts = List();
    for (Map m in listMap){
      //Adicionando os contatos na lista
      listContacts.add(Contact.fromMap(m));
    }
    return listContacts;
  }

  Future<int> getNumber() async {
    //Cria a instancia do database
    Database dbContact = await db;
    //Utilizando rawQuery para contar a quantidade de contatos existentes na tabela
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $TABELA"));
  }

  Future close() async {
    Database dbContact = await db;
    //Fechando banco de dados
    dbContact.close();
  }

}



/*
  id
  name
  email
  phone
  img
 */

class Contact {

  int id;
  String name;
  String email;
  String phone;
  String image;

  Contact();

  Contact.fromMap(Map map){
    id = map[ID_CNT];
    name = map[NAME_CNT];
    email = map[EMAIL_CNT];
    phone = map[PHONE_CNT];
    image = map[IMAGE_CNT];
  }

  Map toMap(){
    Map<String, dynamic> map = {
    NAME_CNT: name,
    EMAIL_CNT: email,
    PHONE_CNT: phone,
    IMAGE_CNT: image,

    };
    if(id != null){
      map[ID_CNT] = id;
    }
    return map;
  }

  @override
  String toString() {
    //Retornar todas as informações do contato
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, image: $image)";
  }
}