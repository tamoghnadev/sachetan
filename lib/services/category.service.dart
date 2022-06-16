import 'package:m_ticket_app/models/category.dart';
import 'package:m_ticket_app/repository/repository.dart';

class CategoryService {
  Repository? _repository;

  CategoryService() {
    _repository = Repository();
  }

  getCategories() async {
    try {
      return await _repository!.httpGet('categories');
    } catch (e) {
      print(e.toString());
    }
  }



  getCategoriesWithOpenedTicketsByUserId(int? userId) async {
    try {
      return await _repository!
          .httpGetById('get-categories-with-opened-tickets-by-user-id', userId);
    } catch (e) {
      print(e.toString());
    }
  }

  deleteCategory(int? categoryId) async {
    try {
      return await _repository!
          .httpGetById('delete-category-by-category-id', categoryId);
    } catch (e) {
      print(e.toString());
    }
  }

  createCategory(Category category) async {
    try {
      return await _repository!.httpPost('create-category', category.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
