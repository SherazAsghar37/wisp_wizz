import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisp_wizz/features/app/constants/app_constants.dart';
import 'package:wisp_wizz/features/app/errors/exceptions.dart';
import 'package:wisp_wizz/features/app/utils/typedef.dart';
import 'package:wisp_wizz/features/auth/data/datasources/local_data_source.dart';
import 'package:wisp_wizz/features/auth/data/models/user_model.dart';

class MSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LocalDatasource localDatasource;
  late SharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MSharedPreferences();
    localDatasource = LocalDatasource(sharedPreferences: sharedPreferences);
  });

  UserModel userModel = UserModel.empty();
  MapData userMap = userModel.toMap();
  group("[Auth Local Datasource] - ", () {
    group("[Cache User Data] - ", () {
      test("It should post set String and return true by calling only once",
          () async {
        //Arrange
        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((invocation) async => true);
        //Act
        final response = localDatasource.cacheUserData(userModel);
        //Assert
        await expectLater(response, completes);
        verify(() =>
                sharedPreferences.setString(sUserDataKey, json.encode(userMap)))
            .called(1);
        verifyNoMoreInteractions(sharedPreferences);
      });
      test("It should post set String and return false by calling only once",
          () async {
        //Arrange
        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((invocation) async => false);
        //Act
        final response = localDatasource.cacheUserData(userModel);
        //Assert
        await expectLater(
            response,
            throwsA(
                const CacheException(message: "Failed to cache user data")));
        verify(() =>
                sharedPreferences.setString(sUserDataKey, json.encode(userMap)))
            .called(1);
        verifyNoMoreInteractions(sharedPreferences);
      });
    });
    group("[Get Cached User Data] - ", () {
      test("It should get String and return userModel by calling only once",
          () async {
        //Arrange
        when(() => sharedPreferences.getString(
              any(),
            )).thenAnswer((invocation) => json.encode(userMap));
        //Act
        final response = localDatasource.getCachedUserData();
        //Assert
        expect(response, equals(userModel));
        verify(() => sharedPreferences.getString(
              sUserDataKey,
            )).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      });
      test("It should get String and return null by calling only once",
          () async {
        //Arrange
        when(() => sharedPreferences.getString(
              any(),
            )).thenAnswer((invocation) => null);
        //Act
        final response = localDatasource.getCachedUserData();
        //Assert
        expect(response, equals(null));
        verify(() => sharedPreferences.getString(
              sUserDataKey,
            )).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      });
    });
    group("[Remove Cached User Data] - ", () {
      test("It should remove String and return null by calling only once",
          () async {
        //Arrange
        when(() => sharedPreferences.remove(
              any(),
            )).thenAnswer((invocation) async => true);
        //Act
        final response = localDatasource.removeCachedUser();
        //Assert
        expect(response, completes);
        verify(() => sharedPreferences.remove(
              sUserDataKey,
            )).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      });
      test(
          "It should remove String and throw cache exception by calling only once",
          () async {
        //Arrange
        when(() => sharedPreferences.remove(
              any(),
            )).thenAnswer((invocation) async => false);
        //Act
        final response = localDatasource.removeCachedUser();
        //Assert
        expect(
            response,
            throwsA(const CacheException(
                message: "Failed to delete cached user data")));
        verify(() => sharedPreferences.remove(
              sUserDataKey,
            )).called(1);
        verifyNoMoreInteractions(sharedPreferences);
      });
    });
  });
}
