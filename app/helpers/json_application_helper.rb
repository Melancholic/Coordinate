module JsonApplicationHelper
    def check_signed
        unless(signed_in?)
            render status: :bad_request, :json => { :success => false, :info => "Your not signed!"} 
        end 
    end
end
