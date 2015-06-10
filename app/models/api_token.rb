##
# Модель для хранения уникальных ключей,
# применяемых при авторизации трекеров 
# в API::V1::Controllers.
##
class ApiToken < ActiveRecord::Base
	# Связь с автомобилем 1 -> 1
    # внешний ключ вхранится в данной модели.
    belongs_to :car
    
    # Обязательный блок, выполняемый
    # перед созданием записи. 
    # Создает и  хеширует ключ.
	before_create do
		self.token=ApiToken.encrypt(ApiToken.new_api_token);
	end
    
    # Метод,  генерирующий уникальный ключ
    # для авторизации API::V1.
	def generate_api_token
	    self.update_attributes(token:ApiToken.encrypt(ApiToken.new_api_token));
	end

private
    # Метод, генерирующий уникальный ключ.
	def ApiToken.new_api_token
		SecureRandom.urlsafe_base64;
	end
	       
    # Метод, выполнующий непосредсвенное шифрование ключа.
    # ==== Attributes
    # *  +sometoken+ - Исходный ключ, требующий хеширования
	def ApiToken.encrypt(sometoken)
		Digest::SHA1.hexdigest(sometoken.to_s)
	end

end
