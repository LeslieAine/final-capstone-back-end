class Api::V1::ReservationsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @reservations = @user.reservations
    render json: @reservations
  end

  def create
    @reservation = Reservation.new(reservation_params)

    if Reservation.exists?(houses_id: @reservation.houses_id)
      render json: { error: 'Already reserved' }, status: :unprocessable_entity
      return
    end

    if @reservation.save
      House.where(id: @reservation.houses_id).update(reservations_id: @reservation.id)
      render json: @reservation, status: :created,
             location: api_v1_user_reservation_url(@reservation.users_id, @reservation)
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])

    @user = User.find(@reservation.users_id)

    if params[:password].blank? || !@user.authenticate(params[:password])
      render json: { error: 'Incorrect password' }, status: :unauthorized
      return
    end

    House.where(id: @reservation.houses_id).update(reservations_id: nil)
    if @reservation.destroy
      render json: { message: 'Reservation successfully deleted' }
    else
      render json: { error: 'Failed to delete reservation' }, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:date, :city, :users_id, :houses_id)
  end
end
