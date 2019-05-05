module TablelessImports
    class TodayTixSingleSales 
        include ActiveModel::Model
   
        attr_accessor :order_num, :sale_date, :section, :num_seats, :pickup_first_name, :pickup_last_name, :puchaser_first_name, :purchaser_last_name, :email,
            :row, :start, :end, :total_price, :performance_date, :zipcode
        
        validates :order_num, presence: true, format: { with: /^T\d{12}$/ }
        validates :row, :section, :purchaser_first_name, :purchaser_last_name, :pickup_first_name, :pickup_last_name, presence: true, format: { with: /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/ }
        validates :zipcode, presence: true, format: { with: /^\d{5}$/ }
        validates :valid_dates?
        validates :total_price, presence: true, format: { with: /^[\d]+\.[\d]{2}$/ }
        validates :num_seats, presence: true, numericality: { only_integer: true }
        validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

        def valid_dates?
            errors.add(:performance_date, 'must be a valid datetime') if ((DateTime.parse(:performance_date) rescue ArgumentError) == ArgumentError)
            errors.add(:sale_date, 'must be a valid datetime') if ((DateTime.parse(:sale_date) rescue ArgumentError) == ArgumentError)
        end

    end

    
    class TodayTixSalesSummary < TodayTixSingleSales
        attr_accessor :num_trans, :purchased_section, :actual_section         
    end
end
