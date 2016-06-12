class BookStepsController < ApplicationController
  include Wicked::Wizard
  steps :name, :author

  def show
    case step
    when :name
      @book = Book.new
      session[:book] = nil
    else
      @book = Book.new(session[:book])
    end
    render_wizard
  end

  def update
    case step
    when :name
      @book = Book.new(book_params)
      session[:book] = @book.attributes
      redirect_to next_wizard_path
    when :author
      session[:book] = session[:book].merge(params[:book])
      @book = Book.new(session[:book])
      @book.save
      redirect_to book_path(@book)
    end
  end

  private

  def finish_wizard_path
    book_path(@book)
  end

  def book_params
    params.require(:book).permit(:name, :author)
  end
end
