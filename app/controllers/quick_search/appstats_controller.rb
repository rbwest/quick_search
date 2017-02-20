module QuickSearch
  class AppstatsController < ApplicationController
    include Auth

    before_action :auth, :start_date, :end_date, :days_in_sample


    ########################## ADDED #############################
    def data
      clicks = Event.where(date_range).where(:action => 'click').group(:created_at).order("created_at ASC").count(:created_at)

      result = []
      clicks.each do |data , count|

        row = { "data" => data ,
                "count" => count}
        result << row
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_module_clicks
      events = Event.where(date_range).where(excluded_categories).where(:action => 'click').group(:category).order("count_category DESC").count(:category)

      result = []
      events.each do |data|

        row = {"action" => data[0],
               "clickcount" => data[1]}
        result << row
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end

    def data_result_clicks
      events = Event.where(date_range).where(:category => "result-types").where(:action => 'click').group(:item).order("count_item DESC").count(:item)

      result = []
      events.each do |data|

        row = {"action" => data[0],
               "clickcount" => data[1]}
        result << row
      end

      respond_to do |format|
        format.json {
          render :json => result
        }
      end
    end
    ##############################################################

    def index
      @page_title = 'Search Statistics'
      search_click_ratio
    end

    def clicks_overview
      @page_title = 'Clicks Overview'
      module_clicks
      result_types_clicks
      typeahead_clicks
    end

    def top_searches
      @page_title = 'Top Searches'
      searches_count
      searches = Search.where(page: '/').where(date_range)
      queries = []
      searches.each do |search|
        queries << search["query"].downcase
      end
      @query_counts = Hash.new(0)
      queries.each do |query|
        @query_counts[query] += 1
      end
      @query_counts = @query_counts.sort_by {|k,v| v}.reverse[0..199]
    end

    def top_spot
      @page_title = params[:ga_top_spot_module]
      top_spot_reporting(params[:ga_top_spot_module])
    end

    def detail
      start_date
      end_date
      @category = params[:ga_category]
      if params[:ga_scope] == 'action'
        @action = params[:ga_action]
        @page_title = "#{@category} (#{URI.decode(@action)})"
        top_spot_detail(@category, @action)
        render "top_spot_detail"
      elsif params[:ga_scope] == 'category'
        @page_title = "#{@category}"
        module_click_detail(@category)
        render "module_click_detail"
      end
    end

    def realtime
    end

    private

    def module_clicks
      @module_clicks = Event.where(date_range).where(excluded_categories).where(:action => 'click').group(:category).order("count_category DESC").count(:category)
      @module_click_total = calculate_total_clicks(@module_clicks)
    end

    def typeahead_clicks
      searches_count
      @typeahead_clicks = Event.where(date_range).where("category LIKE 'typeahead-%'").where(:action => 'click').group(:category).order("count_category DESC").count(:category)
      @typeahead_clicks_total = calculate_total_clicks(@typeahead_clicks)
    end

    def result_types_clicks
      @result_types_clicks = Event.where(date_range).where(:category => "result-types").where(:action => 'click').group(:item).order("count_item DESC").count(:item)
      @result_types_click_total = calculate_total_clicks(@result_types_clicks)
    end

    def calculate_total_clicks(clicks)
      click_total = 0
      clicks.each do |module_name, click_count|
        click_total += click_count
      end

      click_total
    end

    def searches_count
      @searches_count = Search.where(page: '/').where(date_range).count
    end

    def search_click_ratio
      searches_count
      @clicks_count = Event.where(excluded_categories).where(:action => 'click').where(date_range).count
      @click_serve_ratio = (@clicks_count / @searches_count.to_f)*100
    end

    def top_spot_reporting(top_spot_module)
      reports = {"best-bets-regular" => {:category_title => "Best Bets Regular"},
                 "best-bets-algorithmic-journal" => {:category_title => "Journal Algorithmic Best Bets"},
                 "best-bets-algorithmic-database" => {:category_title => "Database Algorithmic Best Bets"},
                 "best-bets-course-tools" => {:category_title => "Course Tools Best Bets"},
                 "spelling-suggestion" => {:category_title => "Spelling Suggestions"}
               }
      @top_spot_reporting = []
      top_spot_report = base_query(top_spot_module)
      @top_spot_reporting << {:category => top_spot_module, :category_title => reports[top_spot_module][:category_title], :report => top_spot_report}
      # reports.each do |key, report|
      #   top_spot_report = base_query(key)
      #   @top_spot_reporting << {:category => key, :category_title => report[:category_title], :report => top_spot_report}
      # end
    end

    def module_click_detail(category)
       modules_clicks = Event.where(:category => category).where(:action => 'click').where(date_range).group(:item).order('count_category DESC').count(:category)
       total_clicks = modules_clicks.values.sum
       @modules_clicks_report = []
       modules_clicks.each do |module_clicks|
        @modules_clicks_report << {:module => module_clicks[0], :clicks => module_clicks[1], :percent => (module_clicks[1]/total_clicks.to_f)*100}
      end
    end

    def top_spot_detail(category, item)
      # Use a join here?
      item = URI.decode(item)
      serves = Event.where(:category => category, :action => 'serve', :item => item).where(date_range).group(:query).order("count_query DESC").count(:query)
      clicks = Event.where(:category => category, :action => 'click', :item => item).where(date_range).group(:query).order("count_query DESC").count(:query)

      @top_spot_detail = {}


      serves.each do |query|
        serve_count = query[1].nil? ? 0:query[1]
        click_count = clicks[query[0].downcase].nil? ? 0:clicks[query[0].downcase]
        @top_spot_detail[query[0]] = [serve_count, click_count, (click_count/serve_count.to_f)*100]
      end
    end

    def base_query(category)
      serves = Event.where(date_range).where(:category => category, :action => 'serve').group(:item).order("count_category DESC").count(:category)
      clicks = Event.where(date_range).where(:category => category, :action => 'click').group(:item).count(:category)

      result = []
      serves.each do |data, count|
        unless clicks[data].nil?
          click_count = clicks[data]
        else
          click_count = 0
        end

        row = {"action" => data,
          "servecount" => count,
          "clickcount" => click_count,
          "click_serve_ratio" => (click_count/count)*100 }
        result << row
      end

      result
    end

    def start_date
      if params[:start_date]
        # If there's a specified start date, use it
        @start_date = convert_to_time(params[:start_date])
      else
        # otherwise use 6 months ago as a default, or the earliest event date if logs are younger
        first_date = Event.first[:created_at]
        start = Time.current - 6.months

        if start < first_date
          @start_date = first_date
        else
          @start_date = start
        end
      end

    end

    def end_date
      if params[:end_date]
        # use end date, if specified
        @end_date = convert_to_time(params[:end_date])
      else
        # otherwise use the current date as default
        @end_date = Time.current
      end
    end

    def convert_to_time(date_input)
      year = date_input[:year]
      month = date_input[:month]
      day = date_input[:day]

      Time.new(year, month, day)
    end

    def days_in_sample
      @days_in_sample = ((@end_date - @start_date) / (24*60*60)).round
      if @days_in_sample < 1
        @days_in_sample = 1
      end
    end

    def excluded_categories
      "category <> \"common-searches\" AND category <> \"result-types\"AND category NOT LIKE \"typeahead-%\""
    end

    def date_range
      { :created_at => start_date.beginning_of_day..end_date.end_of_day }
    end

  end
end
