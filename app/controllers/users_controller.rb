class UsersController < ApplicationController
  def home
    @users = User.all
  end

  def create
    @users = User.all
    file = params[:excel_file]

    successful_records = 0
    failed_records = 0
    failed_record_reason = []

    if file
      xlsx = Roo::Spreadsheet.open(file.path)
      for i in (0..(xlsx.sheets.count - 1)) do  
        xlsx.sheet(i).each_with_index(first_name: 'FIRST_NAME', last_name: 'LAST_NAME',
                                      email: 'EMAIL_ID') do |row, row_index|
                                        
        next if row_index == 0
          user = User.create( first_name: row[:first_name], 
                       last_name: row[:last_name], 
                        email: row[:email]
                      )
          if user.save
            successful_records += 1
          else
            failed_records += 1
            failed_record_reason << "An error: #{user.errors.full_messages.join(', ')}"
          end
        end
      end
      flash[:success] = "Total Records: #{successful_records + failed_records}, Successful: #{successful_records}, Failed: #{failed_records}, Failed_record_reason: #{failed_record_reason}"
      redirect_to users_path
    else
      flash[:error] = "Please select an Excel file to import."
      render :home
    end
  end

  def index
    @users = User.all
  end
end