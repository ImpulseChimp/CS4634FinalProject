class BaseApi < ApplicationController

  attr_accessor :request, :response, :session, :params

  def initialize(request, session, cookies)
    @request = request
    @response = {}
    @session = session
    @cookies = cookies
  end


  def activeRecordToArray(object, list, valid_get_list, id)
    list[id] = {}

    object.attributes.each do |key, value|
      if valid_get_list.include? key
        list[id][key] = value
      end
    end

    return list
  end


  def valid_api_request(required_type, request_type, req_params, exclusive)
    if !parametersExist(req_params, exclusive)
      return false
    end

    true
  end


  def updateActiveRecord(record, request, valid_update_list)

    valid_update_list.each do |validParam|
      if request.include? validParam
        record.update_attribute(validParam, request[validParam])
      end
    end

    record.save
  end


  def parametersExist(parameter_names, exclusive)

    parameter_names.each do |required_name|

      parameter_found = false
      @request.each_key do |request_key|
        if required_name == request_key
          parameter_found = true
          break
        end

      end

      return false if !parameter_found
    end

    return true
    # if exclusive
    #
    #   parameter_names.each do |name|
    #
    #     match_found = false
    #     request.each_key do |param|
    #       puts name + ' ' + param
    #       # If they are equal, then param exists
    #       if name == param
    #         match_found = true
    #         puts 'found'
    #       end
    #     end
    #
    #     # If no match was found, request was bad
    #     if !match_found
    #       return false
    #     end
    #   end
    #
    #   #All names must be valid
    #   return true
    #
    # elsif !exclusive
    #
    #   parameter_names.each do |name|
    #
    #     match_found = false
    #     request.each_key do |param|
    #       puts name + ' ' + param
    #       # If they are equal, then param exists
    #       if name == param
    #         match_found = true
    #         puts 'found'
    #       end
    #     end
    #
    #     # If not match was found, request was bad
    #     if !match_found
    #       return false
    #     end
    #   end
    #
    #   #All names must be valid
    #   return true
    #
    # end

  end
end