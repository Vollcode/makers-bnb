class MakersBNB < Sinatra::Base

  get '/inventories/:id' do
    headers 'Access-Control-Allow-Origin' => '*'
    inventory = Inventory.all(accommodation_id: params[:id], :date.gte => Time.now)
    inventory.to_json
  end

  post '/inventories' do
    start_date = DateTime.strptime(params[:start_date],"%d/%m/%Y")
    end_date = DateTime.strptime(params[:end_date],"%d/%m/%Y")
    flash.next[:errors] =[]

    (start_date..end_date).each do |date|
      inventory = Inventory.create(date: date,
                       booked: false,
                       accommodation_id: params[:accommodation_id])
      flash.next[:errors] << "Could not add #{date.strftime('%d/%m/%Y')}" unless inventory.save
      flash.next[:notice] = 'Inventory sucessfully added' if inventory.save
    end
    redirect back
  end
end
