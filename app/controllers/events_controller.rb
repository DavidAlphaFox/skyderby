# encoding: utf-8
class EventsController < ApplicationController
  before_action :set_event, only:
    [:show, :finished, :update, :destroy, :results]

  def index
    @event = Event.new
  end

  def new
    @event = Event.create(responsible: current_user.user_profile)
    redirect_to @event
  end

  def create
    event_params = params[:event]
    @event = Event.new :name            => event_params[:name],
                       :place           => event_params[:place],
                       :start_at        => Date.parse(event_params[:start_at]),
                       :end_at          => Date.parse(event_params[:end_at]),
                       :comp_range_from => event_params[:comp_range_from],
                       :comp_range_to   => event_params[:comp_range_to]

    @event.organizers.build :user => current_user, :orgs_admin => true,
                            :rounds_admin => true, :competitors_admin => true,
                            :tracks_admin => true
    @event.save
    redirect_to @event, notice: 'Событие успешно создано.'
  end

  def update
    if @event.update event_params
      redirect_to @event, notice: 'Данные успешно обновлены.'
    else
      redirect_to @event, notice: 'При сохранении произошла ошибка.'
    end
  end

  def show
  end

  def results
    render layout: 'full_screen'
  end

  def destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params[:event].permit(:name, :place,
                          :range_from, :range_to,
                          :descriprion, :form_info, :dz_info,
                          :start_at, :end_at, :reg_starts, :reg_ends,
                          :merge_intermediate_and_rookie,
                          :allow_tracksuits, :finished)
  end
end
