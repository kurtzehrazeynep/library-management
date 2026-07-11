require_relative 'library'

system = LibraryManagement.new

loop do
  puts "\n=== BOOK & JSON TEST MENU ==="
  puts "1. Add New Book"
  puts "2. List All Books"
  puts "3. View Total Count Statistics"
  puts "4. Register a member."
  puts "5. List members"
  puts "6. delete book"
  puts "7. Cancel membership registration"
  puts "8. Lend a book."
  puts "9. return book"
  puts "10. Ban member"
  puts "11. Lift the ban"
  puts "12. Exit"
  print "Your choice: "

  choice = gets.chomp
  
  case choice
  when "1"
    print "Enter book ID :"
    id = gets.chomp 
    print "Enter book title: "
    title = gets.chomp
    print "Enter author name:"
    author = gets.chomp
    system.add_book(id,title,author)
  when "2" 
    system.list_all_books
   when "3"
    system.view_total_count_statistics
  when "4"
    print "Enter member ID : "
    id = gets.chomp   
    print "Enter member name"
    member_name = gets.chomp
    system.add_member(id,member_name)
  when "5"
    system.list_all_members
  when "6"
    print "please enter book id: "
    id = gets.chomp
    system.remove_book(id)
  when "7"
    print "Please enter the ID of the member you wish to cancel: "
    id = gets.chomp
    system.delete_member_registration(id)
  when "8"
    print "Please enter the ID of the book you wish to borrow."
    id = gets.chomp
    print "Please enter the member ID of the person to whom the book will be lent. "
    member_id = gets.chomp
    system.lend_book(id,member_id)
  when "9"
    puts "Enter the ID of the member who will make the return."
    member_id = gets.chomp
    puts "Please enter the ID of the book you wish to return."
    id = gets.chomp
    system.return_book(id,member_id)
  when "10"
    puts "Enter the ID of the member to be banned."
    id = gets.chomp
    puts "Enter the reason for the ban."
    ban_reason = gets.chomp
    system.ban_member(id,ban_reason)
  when "11"
    puts "Enter the ID of the user whose ban is to be lifted."
    id = gets.chomp
    reason = ""
    system.lift_the_ban(id,reason)
  when "12"
        puts "Exiting test system. Goodbye!"
    break 
  else
  puts "Invalid option!"
  end
end