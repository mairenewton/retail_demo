view: transactions {
  sql_table_name: retail.transaction_detail ;;

  dimension_group: transaction {
    type: time
    sql: ${TABLE}.transaction_timestamp ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: gross_margin {
    type: number
    sql: ${TABLE}.gross_margin ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: channel_id {
    type: number
    sql: ${TABLE}.channel_id ;;
  }
}
