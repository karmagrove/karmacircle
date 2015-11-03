class TicketPurchasesController < ApplicationController
  before_action :set_ticket_purchase, only: [:show, :edit, :update, :destroy]
  before_action :set_event_and_ticket, only: [:index, :create, :show, :edit, :update, :destroy, :new]
  # GET /ticket_purchases
  # GET /ticket_purchases.json
  def index
    @ticket_purchases = TicketPurchase.all
  end

  # GET /ticket_purchases/1
  # GET /ticket_purchases/1.json
  def show
    @url = "https://www.karmagrove.com/events/#{@event.id}/tickets/#{@ticket_purchase.ticket.id}/ticket_purchases/#{@ticket_purchase.id}"
    @qr = RQRCode::QRCode.new( @url, :size => 7, :level => :h )
  end

  # GET /ticket_purchases/new
  def new
    @ticket_purchase = TicketPurchase.new
  end

  # GET /ticket_purchases/1/edit
  def edit
  end

  # POST /ticket_purchases
  # POST /ticket_purchases.json
  def create
    @ticket_purchase = TicketPurchase.new(ticket_purchase_params)
    @ticket_purchase.ticket_id = params[:ticket_id]
    @ticket_purchase.user_id = current_user.id

    # @ticket_purchase.event
    respond_to do |format|
      if @ticket_purchase.save
        format.html { redirect_to event_ticket_ticket_purchase_url(:id => @ticket_purchase.id, :ticket_id => @ticket_purchase.ticket_id), notice: 'Ticket purchase was successfully created.' }
        format.json { render :show, status: :created, location: @ticket_purchase }
      else
        format.html { render :new }
        format.json { render json: @ticket_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ticket_purchases/1
  # PATCH/PUT /ticket_purchases/1.json
  def update

    respond_to do |format|
      if @ticket_purchase.update(ticket_purchase_params)
        @ticket_purchase.send_ticket
        format.html { redirect_to event_ticket_ticket_purchase_url(:id => @ticket_purchase.id, :ticket_id => @ticket_purchase.ticket_id), notice: 'Ticket purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket_purchase }
      else
        format.html { render :edit }
        format.json { render json: @ticket_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_purchases/1
  # DELETE /ticket_purchases/1.json
  def destroy
    @ticket_purchase.destroy
    respond_to do |format|
      format.html { redirect_to event_ticket_ticket_purchase_url(:id => @ticket_purchase.id, :ticket_id => @ticket_purchase.ticket_id), notice: 'Ticket purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_event_and_ticket
      @event = Event.find params[:event_id]
      @ticket = Ticket.find params[:ticket_id]
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_purchase
      @ticket_purchase = TicketPurchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_purchase_params
      params.require(:ticket_purchase).permit(:ticket_id, :status, :payment_reference_url, :buyer_email, :user_id)
    end
end
