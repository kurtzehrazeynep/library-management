require 'json'
require_relative 'book'
require_relative 'member'

class LibraryManagement
  attr_accessor :bookshelf, :members

  def initialize
    @bookshelf = []
    @members = []
    load_books_to_json
    load_members_to_json
  end

  def add_book(id, title, author)
    new_book = InventoryEntry.new(id, title, author)
    @bookshelf << new_book
    save_books_to_json
    puts "Book successfully saved!"
  end

  def list_all_books
    if @bookshelf.empty?
      puts "The Bookshelf is empty!"
    else
      puts "\n--- Current Bookshelf Inventory ---"
      @bookshelf.each do |b|
        status = b.in_library ? "In Library" : "Borrowed"
        puts "- #[#{b.id}] #{b.book_title} by #{b.author_name} [#{status}]"
      end
    end
  end

  def view_total_count_statistics
    puts "Total Books: #{InventoryEntry.read_outside}"
    puts "Total Members: #{Member.read_outside}"
  end

  def add_member(id, member_name)
    new_member = Member.new(id, member_name)
    @members << new_member
    save_members_to_json
    puts "Member successfully saved!"
  end

  def list_all_members
     if @members.empty?
      puts "⚠️ No registered members found."
     else
      puts "\n--- Registered Members List ---"
      @members.each do |m|
      status = m.is_banned ? "🚫 BANNED (Reason: #{m.ban_reason})" : "Active"
      # Üye pasifse durumuna bunu yazdıralım
      status = "DEACTIVATED" if !m.is_the_member_registered 
      
      puts "- #[#{m.id}] #{m.member_name} | Books Borrowed: #{m.borrowed_books_count} | Status: #{status}"
       end
     end
  end 

  def remove_book(id)
    book = @bookshelf.find { |b| b.id.to_s == id.to_s }
    if book
      if book.in_library
        @bookshelf.delete(book)
        save_books_to_json
        puts "Book ID #{id} has been removed from the library."
      else
        puts "⚠️ Cannot remove book! It is currently borrowed."
      end
    else
      puts "⚠️ Book not found."
    end
  end

  def delete_member_registration(id)
     member = @members.find { |m| m.id.to_s == id.to_s }
      if member
        if member.borrowed_books_count == 0
           member.is_the_member_registered = false 
            save_members_to_json
            puts "Member ID #{id} registration cancelled (Account deactivated)."
        else
            puts "⚠️ Cannot cancel membership! Member has unreturned books."
        end
      else
        puts "⚠️ Member not found."
      end
  end

  def lend_book(id, member_id)
    book = @bookshelf.find { |b| b.id.to_s == id.to_s }
    member = @members.find { |m| m.id.to_s == member_id.to_s }

    if book.nil?
      puts "⚠️ Book not found."
      return
    end

    if member.nil?
      puts "⚠️ Member not found."
      return
    end

    if !member.is_the_member_registered
      puts "⚠️ Lending failed! Member registration is cancelled."
      return
    end

    if member.is_banned
      puts "🚫 Lending failed! Member is banned."
      return
    end

    if book.in_library
      book.in_library = false
      member.borrowed_books_count += 1
      member.borrowed_books_list << book.book_title
      save_books_to_json
      save_members_to_json
      puts "Book '#{book.book_title}' successfully lent to #{member.member_name}."
    else
      puts "⚠️ Book is already borrowed by someone else."
    end
  end

  def return_book(id, member_id)
    book = @bookshelf.find { |b| b.id.to_s == id.to_s }
    member = @members.find { |m| m.id.to_s == member_id.to_s }

    if book.nil? || member.nil?
      puts "⚠️ Invalid book or member ID."
      return
    end

    if !book.in_library && member.borrowed_books_list.include?(book.book_title)
      book.in_library = true
      member.borrowed_books_count -= 1
      member.borrowed_books_list.delete(book.book_title)
      save_books_to_json
      save_members_to_json
      puts "Book successfully returned."
    else
      puts "⚠️ This book was not borrowed by this member."
    end
  end

  def ban_member(id, ban_reason)
    member = @members.find { |m| m.id.to_s == id.to_s }
    if member
      member.is_banned = true
      member.ban_reason = ban_reason
      save_members_to_json
      puts "🚫 Member #{member.member_name} has been banned. Reason: #{ban_reason}"
    else
      puts "⚠️ Member not found."
    end
  end

  def lift_the_ban(id, reason = "")
    member = @members.find { |m| m.id.to_s == id.to_s }
    if member
      member.is_banned = false
      member.ban_reason = ""
      save_members_to_json
      puts "Ban lifted for member #{member.member_name}."
    else
      puts "⚠️ Member not found."
    end
  end

  private

  def save_books_to_json
    books_hash_array = @bookshelf.map { |book| book.to_h }
    File.write('books.json', JSON.pretty_generate(books_hash_array))
  end

  def load_books_to_json
    if File.exist?('books.json') && !File.read('books.json').empty?
      begin
        saved_books = JSON.parse(File.read('books.json'))
        saved_books.each do |b|
          @bookshelf << InventoryEntry.new(b['id'], b['book_title'], b['author_name'], b['in_library'])
        end
      rescue JSON::ParserError => e
        puts "⚠️ Error reading books JSON: #{e.message}"
      end
    end
  end

  def save_members_to_json
    members_hash_array = @members.map { |member| member.to_h }
    File.write('member.json', JSON.pretty_generate(members_hash_array))
  end

 def load_members_to_json
   if File.exist?('member.json') && !File.read('member.json').empty?
     begin
       saved_members = JSON.parse(File.read('member.json'))
       saved_members.each do |m|
         b_count = m['borrowed_books_count'] || 0
         b_list  = m['borrowed_book_list'] || []
         banned  = m['is_banned'] || false
         reason  = m['ban_reason'] || ""
         is_registered = m.key?('is_the_member_registered') ? m['is_the_member_registered'] : true
         @members << Member.new(m['id'], m['member_name'], b_count, b_list, banned, reason, is_registered)
       end
     rescue JSON::ParserError => e
       puts "⚠️ Error reading members JSON: #{e.message}"
     end
   end
 end
end