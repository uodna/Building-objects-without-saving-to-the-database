class BookStepsController < ApplicationController
  include Wicked::Wizard
  steps(*Book.form_steps)

  def show
    case step
    when :name
      @book = Book.new
      session[:book] = {}
    else
      @book = Book.new(session[:book])
    end
    render_wizard
  end

  def update
    session[:book] = session[:book].merge(book_params)
    @book = Book.new(session[:book])
    return render_wizard if @book.invalid?

    case step
    when :name
      redirect_to next_wizard_path
    when :author
      @book.save
      session[:book] = nil
      redirect_to book_path(@book)
    end
  end

  private

  def finish_wizard_path
    book_path(@book)
  end

  def book_params
    params.require(:book).permit(:name, :author).merge(form_step: step)
  end
end
