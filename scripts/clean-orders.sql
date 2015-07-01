# Tested on Magento CE 1.4.1.1 - 1.9.0.1
 
SET FOREIGN_KEY_CHECKS=0;
 
##############################
# SALES RELATED TABLES
##############################
TRUNCATE `sales_flat_creditmemo`;
TRUNCATE `sales_flat_creditmemo_comment`;
TRUNCATE `sales_flat_creditmemo_grid`;
TRUNCATE `sales_flat_creditmemo_item`;
TRUNCATE `sales_flat_invoice`;
TRUNCATE `sales_flat_invoice_comment`;
TRUNCATE `sales_flat_invoice_grid`;
TRUNCATE `sales_flat_invoice_item`;
TRUNCATE `sales_flat_order`;
TRUNCATE `sales_flat_order_address`;
TRUNCATE `sales_flat_order_grid`;
TRUNCATE `sales_flat_order_item`;
TRUNCATE `sales_flat_order_payment`;
TRUNCATE `sales_flat_order_status_history`;
TRUNCATE `sales_flat_quote`;
TRUNCATE `sales_flat_quote_address`;
TRUNCATE `sales_flat_quote_address_item`;
TRUNCATE `sales_flat_quote_item`;
TRUNCATE `sales_flat_quote_item_option`;
TRUNCATE `sales_flat_quote_payment`;
TRUNCATE `sales_flat_quote_shipping_rate`;
TRUNCATE `sales_flat_shipment`;
TRUNCATE `sales_flat_shipment_comment`;
TRUNCATE `sales_flat_shipment_grid`;
TRUNCATE `sales_flat_shipment_item`;
TRUNCATE `sales_flat_shipment_track`;
TRUNCATE `sales_invoiced_aggregated`;            # ??
TRUNCATE `sales_invoiced_aggregated_order`;        # ??
TRUNCATE `log_quote`;
 
ALTER TABLE `sales_flat_creditmemo_comment` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_creditmemo_grid` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_creditmemo_item` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_invoice` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_invoice_comment` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_invoice_grid` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_invoice_item` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_order` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_order_address` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_order_grid` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_order_item` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_order_payment` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_order_status_history` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote_address` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote_address_item` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote_item` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote_item_option` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote_payment` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_quote_shipping_rate` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_shipment` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_shipment_comment` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_shipment_grid` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_shipment_item` AUTO_INCREMENT=1;
ALTER TABLE `sales_flat_shipment_track` AUTO_INCREMENT=1;
ALTER TABLE `sales_invoiced_aggregated` AUTO_INCREMENT=1;
ALTER TABLE `sales_invoiced_aggregated_order` AUTO_INCREMENT=1;
ALTER TABLE `log_quote` AUTO_INCREMENT=1;
 
#########################################
# DOWNLOADABLE PURCHASED
#########################################
TRUNCATE `downloadable_link_purchased`;
TRUNCATE `downloadable_link_purchased_item`;
 
ALTER TABLE `downloadable_link_purchased` AUTO_INCREMENT=1;
ALTER TABLE `downloadable_link_purchased_item` AUTO_INCREMENT=1;
 
#########################################
# RESET ID COUNTERS
#########################################
TRUNCATE `eav_entity_store`;
ALTER TABLE  `eav_entity_store` AUTO_INCREMENT=1;
 
 
##############################
# CUSTOMER RELATED TABLES
##############################
TRUNCATE `customer_address_entity`;
TRUNCATE `customer_address_entity_datetime`;
TRUNCATE `customer_address_entity_decimal`;
TRUNCATE `customer_address_entity_int`;
TRUNCATE `customer_address_entity_text`;
TRUNCATE `customer_address_entity_varchar`;
TRUNCATE `customer_entity`;
TRUNCATE `customer_entity_datetime`;
TRUNCATE `customer_entity_decimal`;
TRUNCATE `customer_entity_int`;
TRUNCATE `customer_entity_text`;
TRUNCATE `customer_entity_varchar`;
TRUNCATE `tag`;
TRUNCATE `tag_relation`;
TRUNCATE `tag_summary`;
TRUNCATE `tag_properties`;            ## CHECK ME
TRUNCATE `wishlist`;
TRUNCATE `log_customer`;
 
ALTER TABLE `customer_address_entity` AUTO_INCREMENT=1;
ALTER TABLE `customer_address_entity_datetime` AUTO_INCREMENT=1;
ALTER TABLE `customer_address_entity_decimal` AUTO_INCREMENT=1;
ALTER TABLE `customer_address_entity_int` AUTO_INCREMENT=1;
ALTER TABLE `customer_address_entity_text` AUTO_INCREMENT=1;
ALTER TABLE `customer_address_entity_varchar` AUTO_INCREMENT=1;
ALTER TABLE `customer_entity` AUTO_INCREMENT=1;
ALTER TABLE `customer_entity_datetime` AUTO_INCREMENT=1;
ALTER TABLE `customer_entity_decimal` AUTO_INCREMENT=1;
ALTER TABLE `customer_entity_int` AUTO_INCREMENT=1;
ALTER TABLE `customer_entity_text` AUTO_INCREMENT=1;
ALTER TABLE `customer_entity_varchar` AUTO_INCREMENT=1;
ALTER TABLE `tag` AUTO_INCREMENT=1;
ALTER TABLE `tag_relation` AUTO_INCREMENT=1;
ALTER TABLE `tag_summary` AUTO_INCREMENT=1;
ALTER TABLE `tag_properties` AUTO_INCREMENT=1;
ALTER TABLE `wishlist` AUTO_INCREMENT=1;
ALTER TABLE `log_customer` AUTO_INCREMENT=1;
 
 
##############################
# ADDITIONAL LOGS
##############################
TRUNCATE `log_url`;
TRUNCATE `log_url_info`;
TRUNCATE `log_visitor`;
TRUNCATE `log_visitor_info`;
TRUNCATE `report_event`;
TRUNCATE `report_viewed_product_index`;
TRUNCATE `sendfriend_log`;
### ??? TRUNCATE `log_summary`
 
ALTER TABLE `log_url` AUTO_INCREMENT=1;
ALTER TABLE `log_url_info` AUTO_INCREMENT=1;
ALTER TABLE `log_visitor` AUTO_INCREMENT=1;
ALTER TABLE `log_visitor_info` AUTO_INCREMENT=1;
ALTER TABLE `report_event` AUTO_INCREMENT=1;
ALTER TABLE `report_viewed_product_index` AUTO_INCREMENT=1;
ALTER TABLE `sendfriend_log` AUTO_INCREMENT=1;
### ??? ALTER TABLE `log_summary` AUTO_INCREMENT=1;
 
SET FOREIGN_KEY_CHECKS=1;
