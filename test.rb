require 'minitest/autorun'
require_relative 'library'

class TestLibraryManagement < Minitest::Test
  def setup
    @library = LibraryManagement.new
    @library.bookshelf.clear
    @library.members.clear
    InventoryEntry.class_variable_set(:@@total_books_count, 0)
    Member.class_variable_set(:@@total_members_count, 0)
  end
  def test_cannot_remove_borrowed_book
    @library.add_book("101", "Nutuk", "Atatürk")
    @library.add_member("M1", "Zehra Zeynep")
    
    @library.lend_book("101", "M1")
    @library.remove_book("101")    
    assert_equal 1, @library.bookshelf.count, "A borrowed book must not be deleted from the system!"
  end
  def test_ban_member_and_prevent_lending
    @library.add_book("101", "Nutuk", "Atatürk")
    @library.add_member("M1", "Zehra Zeynep")
    
    @library.ban_member("M1", "Rule violation") 
    @library.lend_book("101", "M1")          

    book = @library.bookshelf.find { |b| b.id.to_s == "101" }
    assert book.in_library, "A suspended member must not borrow books!"
  end
  def test_banned_member_can_still_return_books
    @library.add_book("101", "Nutuk", "Atatürk")
    @library.add_member("M1", "Zehra Zeynep")
    
    @library.lend_book("101", "M1")          
    @library.ban_member("M1", "Geç iade")    
    @library.return_book("101", "M1")            
    book = @library.bookshelf.find { |b| b.id.to_s == "101" }
    assert book.in_library, "The book can be successfully returned even if the member is banned."
  end
  def test_lift_the_ban_successfully
    @library.add_member("M1", "Zehra Zeynep")
    @library.ban_member("M1", "Temporary Ban")
    @library.lift_the_ban("M1") 
    
    member = @members.nil? ? @library.members.find { |m| m.id.to_s == "M1" } : @members.find { |m| m.id.to_s == "M1" }
    refute member.is_banned, "The member's ban must have been successfully lifted.."
  end
end