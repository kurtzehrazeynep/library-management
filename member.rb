class Member
  attr_accessor :borrowed_books_count, :borrowed_books_list, :is_banned, :ban_reason, :is_the_member_registered
  attr_reader :member_name, :id

  @@total_members_count = 0 
  
  def initialize(id, member_name, borrowed_books_count = 0, borrowed_books_list = [], is_banned = false, ban_reason = "", is_the_member_registered = true)
    @id = id
    @member_name = member_name
    @is_the_member_registered = is_the_member_registered
    @borrowed_books_count = borrowed_books_count
    @borrowed_books_list = borrowed_books_list
    @@total_members_count += 1
    @is_banned = is_banned
    @ban_reason = ban_reason
  end
  def to_h 
    { 
      id: @id,
      member_name: @member_name,
      is_the_member_registered: @is_the_member_registered,
      is_banned: @is_banned,
      ban_reason: @ban_reason,
      borrowed_book_list: @borrowed_books_list,
      borrowed_books_count: @borrowed_books_count
    }
  end

  def self.read_outside
    @@total_members_count 
  end
end