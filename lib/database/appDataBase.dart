import 'package:tinano/tinano.dart';
import 'dart:async';
import '../api/category/model.dart';
import '../api/news/model.dart';
part 'appDatabase.g.dart'; // this is important!

@TinanoDb(name: "news_app.sqlite", schemaVersion: 2)
abstract class AppDatabase {
  static DatabaseBuilder<AppDatabase> createBuilder() => _$createAppDatabase();

  @Query("SELECT COUNT(*) FROM categories")
  Future<int> getAllCategoryCount();

  @Query("SELECT * FROM categories")
  Future<List<Category>> getAllCategory();

  @Query('Delete from categories')
  Future<int> deleteAllCategory();

  @Insert(
    "INSERT INTO categories (name,imageUrl,description) VALUES (:name,:image,:description)",
  )
  Future<int> createCategory(String name, String image, String description);

  /**
   * NEWS
   */
  @Query("SELECT COUNT(*) FROM news")
  Future<int> getAllNewsCount();

  @Query("SELECT * FROM news")
  Future<List<News>> getAllNews();

  @Query("SELECT * FROM news where categoryId = :categoryId")
  Future<List<News>> getAllNewsForCategory(int categoryId);

  @Query('Delete from news')
  Future<int> deleteAllNews();

  @Insert(
      "INSERT INTO news (id,title,body,image,categoryId,type,published,publishedAt,categoryName) VALUES (:id,:title,:body,:image,:categoryId,:type,:published,:publishedAt,:categoryName)")
  Future<int> createNews(
      int id,
      String title,
      String body,
      String image,
      int categoryId,
      String type,
      int published,
      String publishedAt,
      String categoryName);

  static Future<AppDatabase> openMyDatabase() async {
    return await (AppDatabase.createBuilder().doOnCreate((db, version) async {
      await db.execute("""
        CREATE TABLE `categories` ( `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `imageUrl` TEXT  NULL, `description` TEXT  NULL );
        """);
      await db.execute("""
        CREATE TABLE `news` ( 
          `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
          `name` TEXT NULL,
          `title` TEXT NULL,
          `body` TEXT NULL,
          `image` TEXT NULL,
          `categoryId` INT NULL,
          `type` TEXT NULL,
          `published` INT NULL,
          `publishedAt` TEXT NULL,
          `categoryName` TEXT NULL
          );""");
    }).build());
  }
}
