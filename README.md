* Command for bulding the image


	docker build --tag="dgreco/cm5:v1" .

* Create a container with the following command:


		docker run -h docker -i -d \
 						-p 22:22 \
 						-p 7180:7180 \
					 	-p 50010:50010 \
					 	-p 50075:50075 \
					 	-p 50020:50020 \
					 	-p 8020:8020 \
 						-p 50070:50070 \
 						-p 50090:50090 \
			 			-p 8032:8032 \
					 	-p 8030:8030 \
					 	-p 8031:8031 \
				 		-p 8033:8033 \
					 	-p 8088:8088 \
					 	-p 8040:8040 \
					 	-p 8042:8042 \
					 	-p 8041:8041 \
					 	-p 10020:10020 \
					 	-p 19888:19888 \
					 	-p 41370:41370 \
		 				-p 38319:38319 \
 						-t dgreco/cm5:v1
 						
* This container will start a cloudere manager service that could use for creating all the services you need.
 