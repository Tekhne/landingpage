class ContactsController < ApplicationController
  def create
    Subscriptions.new.subscribe(create_params)
    redirect_to(
      contact_path,
      flash: { contacts_create_success: true },
      status: :see_other
    )
  rescue Subscriptions::Error => exception
    flash.now.alert = exception.message
    @contact = build_contact(exception)
    render :new
  end

  def new
    @contact = Contact.new
  end

  def show
    redirect_to new_contact_path unless flash[:contacts_create_success]
  end

  private

  def create_params
    params.require(:contact).permit(:email)
  end

  def build_contact(exception)
    record_is_contact = defined?(exception.original_exception.record) &&
                        exception.original_exception.record.is_a?(Contact)
    record_is_contact ? exception.original_exception.record : Contact.new
  end
end
