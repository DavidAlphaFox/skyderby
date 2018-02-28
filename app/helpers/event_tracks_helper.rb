module EventTracksHelper
  def new_event_track_link(event, competitor, round, display_raw_results)
    link_to content_tag('i', nil, class: 'fa fa-upload'),
            new_event_event_track_path(event),
            remote: true,
            'data-params': { 'event_track[competitor_id]' => competitor.id,
                             'event_track[round_id]' => round.id,
                             display_raw_results: display_raw_results }.to_param,
            class: 'create-result-cell__link',
            rel: 'nofollow'
  end
end
