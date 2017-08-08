# frozen_string_literal: true

module FirstACH
  module Customer
    class Profile
      include FirstACH::XML

      # Create Customer Profile
      # @param name                 [String - Alphanumeric 50]  Name of Customer
      # @param id                   [String - Alphanumeric 50]  Merchant-specified identifier of Customer
      # @param address              [String - Alphanumeric 100] Address of Customer
      # @param city                 [String - Alpha 50]         City of Customer
      # @param state                [String - Alpha 2]          Valid 2-character state abbreviation
      # @param zip                  [String - Numeric 5]        Zip code of Customer
      # @param phone                [String - Alphanumeric 12]  Phone number of Customer: xxx-xxx-xxxx
      # @param email                [String - Alphanumeric 50]  Email address of Customer
      # @param fax                  [String - Alphanumeric 12]  Fax number of Customer: xxx-xxx-xxxx
      # @param driver_licence_id    [String - Alphanumeric 50]  Driver's License ID number of Customer
      # @param driver_licence_state [String - Alpha 2]          Valid 2-character state abbreviation
      def self.create(name:, id: nil, address:, city:, state:, zip:, phone:, email: nil, fax: nil, driver_licence_id: nil, driver_licence_state: nil)
        parameters                = arguments(__method__, binding)
        parameters[:customerName] = parameters.delete(:name)
        parameters[:customerID]   = parameters.delete(:id)
        parameters[:address1]     = parameters.delete(:address)
        parameters[:drvLic]       = parameters.delete(:driver_licence_id)
        parameters[:drvState]     = parameters.delete(:driver_licence_state)

        build_document('createCustomerProfile') do |document|
          build_object(document, 'customerProfile', parameters)
        end
      end

      # UpdateCustomerProfile
      # DeleteCustomerProfile
    end
  end
end
