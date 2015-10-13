class TicketPurchasesController < ApplicationController
  before_action :set_ticket_purchase, only: [:show, :edit, :update, :destroy]

  # GET /ticket_purchases
  # GET /ticket_purchases.json
  def index
    @ticket_purchases = TicketPurchase.all
  end

  # GET /ticket_purchases/1
  # GET /ticket_purchases/1.json
  def show
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

    respond_to do |format|
      if @ticket_purchase.save
        format.html { redirect_to @ticket_purchase, notice: 'Ticket purchase was successfully created.' }
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
        format.html { redirect_to @ticket_purchase, notice: 'Ticket purchase was successfully updated.' }
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
      format.html { redirect_to ticket_purchases_url, notice: 'Ticket purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_purchase
      @ticket_purchase = TicketPurchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_purchase_params
      params.require(:ticket_purchase).permit(:ticket_id, :payment_reference_url, :buyer_email, :user_id)
    end
end
