import 'package:dio/dio.dart';
import 'package:radio_app/Models/database.dart';
import 'package:radio_app/Models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiController {
  Dio _dio;
  String _token;
  ApiController() {
    _dio = Dio();
  }
  // Login and Get Token

  Future<String> login(email, password) async {
    FormData formData =
        FormData.fromMap({'email': email, 'password': password});
    // Response response;
    _dio.options.headers['accept'] = 'application/json';

    return await _dio
        .post('https://radio-api.herokuapp.com/api/login',
            data: formData,
            options: Options(
                contentType: 'application/json',
                headers: {'Accept': 'application/json'}))
        .then((Response response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        _token = response.data['token'];
        storeTokenDetails(_token, email, password);
        return 'Success';
      }
    }).catchError((error) {
      if (error.toString().contains('401'))
        return 'Unauthorized';
      else
        return 'Failed';
    });
  }

  // Register to store in system
  Future<String> register(name, email, password) async {
    FormData formData =
        FormData.fromMap({'email': email, 'name': name, 'password': password});
    _dio.options.headers['accept'] = 'application/json';
    return await _dio
        .post('https://radio-api.herokuapp.com/api/register', data: formData)
        .then((Response response) {
      if (response.statusCode == 201) {
        _token = response.data['token'];
        storeTokenDetails(_token, email, password);
        return 'Success';
      }
    }).catchError((error) {
      if (error.toString().contains('500'))
        return 'Email Exists';
      else
        return 'failed';
    });
  }

  // Fetch messages from API
  Future<List<Data>> fetchMessages() async {
    String token = await getTokenDetails();
    Message message;
    Response _response;
    print('About to fetch messages');
    await _dio
        .get('https://radio-api.herokuapp.com/api/messages/index',
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            }))
        .then((response) {
      print(response);
      _response = response;
      if (response.statusCode == 200) {
        String messageString = jsonEncode(response.data);
        Map messageMap = json.decode(messageString);

        message = Message.fromJson(messageMap);
      } else {
        throw Exception('Failed to load messages');
      }
    }).catchError((error) {
      print(error);
    });
    if (_response.statusCode == 200) {
      // Loop through messages
      for (var object in message.data) {
        // Storing data in sqlite database
        await MessageDatabaseProvider.db.addMessagetoDB(object);

        print('Saving to database complete with result');
        // print(res);
      }
    }
    // Setting the fetchedMessagesState
    setFetchedMessagesState(true);
    return message.data;
    // print(response);
  }

  Future<List<Data>> fetchMessagesfromDB() async {
    List<Data> messages = await MessageDatabaseProvider.db.getAllMessages();
    return messages;
  }

  Future<void> storeTokenDetails(
      String token, String email, String password) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('token', token);
    _prefs.setString('email', email);
    _prefs.setString('password', password);
  }

  Future<String> getTokenDetails() async {
    final _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token') ?? '';
    return token;
  }

  Future<void> setFetchedMessagesState(bool fetchMessagesState) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('fetchMessageState', fetchMessagesState);
  }

  Future<bool> get fetchedMessagesState async {
    final _prefs = await SharedPreferences.getInstance();
    bool fetchMessagesState = _prefs.getBool('fetchMessageState') ?? false;
    return fetchMessagesState;
  }

  Future<void> setFavoriteMessagesState(bool favoriteState) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('favoriteState', favoriteState);
  }

  Future<bool> get favoriteMessageState async {
    final _prefs = await SharedPreferences.getInstance();
    bool favoriteState = _prefs.getBool('favoriteState') ?? false;
    return favoriteState;
  }

  Future<List<int>> get favoriteMessagesIds async {
    // State to control whether favories are empty or not
    final _prefs = await SharedPreferences.getInstance();
    List<String> stringIds = _prefs.getStringList('favorites') ?? null;
    // Convert String ids to integers
    List<int> intIds = List();
    if (stringIds.isEmpty)
      setFavoriteMessagesState(false);
    else {
      setFavoriteMessagesState(true);
      for (var item in stringIds) {
        intIds.add(int.tryParse(item));
      }
    }
    return intIds;
  }

  Future<List<Data>> get favoriteMessages async {
    // Collect Integer ids
    List<int> ids = await favoriteMessagesIds;
    return await MessageDatabaseProvider.db.getMessages(ids);
  }

// Remove token for delete
  Future<void> removeToken(String token) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.remove(token);
  }
}
