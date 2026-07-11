class InventoryEntry
  attr_accessor :in_library, :id
  attr_reader :book_title, :author_name
  
  @@total_books_count = 0

  def initialize(id, book_title, author_name, in_library = true)
    @id = id
    @book_title = book_title
    @author_name = author_name
    @in_library = in_library # Her zaman true yapmak yerine dışarıdan gelen değeri kullanıyoruz
    @@total_books_count += 1
    puts "New book: '#{@book_title}-#{@author_name}' has been added."
  end

  def self.read_outside
    @@total_books_count
  end

  # to_h metoduna ID eklendi, aksi halde JSON'a kaydedilmez
  def to_h 
    {
      id: @id,
      book_title: @book_title,
      author_name: @author_name,
      in_library: @in_library
    }
  end
end