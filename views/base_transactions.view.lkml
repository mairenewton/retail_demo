include: "date_comparison.view.lkml"

view: transactions {
  sql_table_name: retail_demo.transaction_detail ;;

  extends: [date_comparison]

  dimension: channel_id {
    type: number
    sql: ${TABLE}.channel_id ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: line_items {
    hidden: yes
    sql: ${TABLE}.line_items ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}.transaction_id ;;
  }

  dimension_group: transaction {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      week_of_year
    ]
    sql: ${TABLE}.transaction_timestamp ;;
  }

  ##### DERIVED DIMENSIONS #####

  extends: [date_comparison]

  set: drill_detail {
    fields: [transaction_date, stores.name, products.area, products.name, transactions__line_items.total_sales, number_of_transactions]
  }

  dimension_group: since_first_customer_transaction {
    type: duration
    intervals: [month]
    sql_start: ${customer_facts.customer_first_purchase_raw} ;;
    sql_end: CURRENT_TIMESTAMP() ;;
  }

  ##### MEASURES #####

  measure: number_of_transactions {
    type: count_distinct
    sql: ${transactions.transaction_id} ;;
    value_format_name: decimal_0
    drill_fields: [drill_detail*]
  }

  measure: number_of_customers {
    type: count_distinct
    sql: ${transactions.customer_id} ;;
    value_format_name: decimal_0
    drill_fields: [drill_detail*]
  }

  measure: number_of_stores {
    view_label: "Stores 🏪"
    type: count_distinct
    sql: ${transactions.store_id} ;;
    value_format_name: decimal_0
    drill_fields: [drill_detail*]
  }

  measure: number_of_customer_transactions {
    hidden: yes
    type: count_distinct
    sql: ${transaction_id} ;;
    filters: {
      field: customer_id
      value: "NOT NULL"
    }
  }

  measure: percent_customer_transactions {
    type: number
    sql: ${number_of_customer_transactions}/NULLIF(${number_of_transactions},0) ;;
    value_format_name: percent_1
    drill_fields: [drill_detail*]
  }

  measure: first_transaction {
    type: date
    sql: MIN(${transaction_raw}) ;;
    drill_fields: [drill_detail*]
  }

  ##### DATE COMPARISON MEASURES #####

  measure: number_of_transactions_change {
    view_label: "Date Comparison"
    label: "Number of Transactions Change (%)"
    type: number
    sql: COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'This%' THEN ${transaction_id} ELSE NULL END) / NULLIF(COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'Prior%' THEN ${transaction_id} ELSE NULL END),0) -1;;
    value_format_name: percent_1
    drill_fields: [drill_detail*]
  }

  measure: number_of_customers_change {
    view_label: "Date Comparison"
    label: "Number of Customers Change (%)"
    type: number
    sql: COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'This%' THEN ${customer_id} ELSE NULL END) / NULLIF(COUNT(distinct CASE WHEN ${transactions.selected_comparison} LIKE 'Prior%' THEN ${customer_id} ELSE NULL END),0) -1;;
    value_format_name: percent_1
    drill_fields: [drill_detail*]
  }

  ##### PER STORE MEASURES #####

  measure: number_of_transactions_per_store {
    view_label: "Stores 🏪"
    type: number
    sql: ${number_of_transactions}/NULLIF(${number_of_stores},0) ;;
    value_format_name: decimal_0
    drill_fields: [transactions.drill_detail*]
  }
}

view: transactions__line_items {
  label: "Transactions"

  dimension: gross_margin {
    type: number
    sql: ${TABLE}.gross_margin ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  ##### DERIVED DIMENSIONS #####


  ##### MEASURES #####

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    drill_fields: [transactions.drill_detail*]
  }

  measure: total_gross_margin {
    type: sum
    sql: ${gross_margin} ;;
    value_format_name: usd_0
    drill_fields: [transactions.drill_detail*]
  }

  measure: total_quantity {
    type: sum
    sql: 1 ;;
    value_format_name: decimal_0
    drill_fields: [transactions.drill_detail*]
  }

  measure: average_basket_size {
    type: number
    sql: ${total_sales}/NULLIF(${transactions.number_of_transactions},0) ;;
    value_format_name: usd
    drill_fields: [transactions.drill_detail*]
  }

  measure: average_item_price {
    type: number
    sql: ${total_sales}/NULLIF(${total_quantity},0) ;;
    value_format_name: usd
    drill_fields: [transactions.drill_detail*]
  }

  ##### DATE COMPARISON MEASURES #####

  measure: sales_change {
    view_label: "Date Comparison"
    label: "Sales Change (%)"
    type: number
    sql: SUM(CASE WHEN ${transactions.selected_comparison} LIKE 'This%' THEN ${transactions__line_items.sale_price} ELSE NULL END) / NULLIF(SUM(CASE WHEN ${transactions.selected_comparison} LIKE 'Prior%' THEN ${transactions__line_items.sale_price} ELSE NULL END),0) -1;;
    value_format_name: percent_1
    drill_fields: [transactions.drill_detail*]
  }

  ##### PER STORE MEASURES #####

  measure: total_sales_per_store {
    view_label: "Stores 🏪"
    type: number
    sql: ${total_sales}/NULLIF(${transactions.number_of_stores},0) ;;
    value_format_name: usd_0
    drill_fields: [transactions.drill_detail*]
  }

  measure: total_quantity_per_store {
    view_label: "Stores 🏪"
    type: number
    sql: ${total_quantity}/NULLIF(${transactions.number_of_stores},0) ;;
    value_format_name: decimal_0
    drill_fields: [transactions.drill_detail*]
  }

  ##### PER ADDRESS MEASURES #####

  measure: number_of_addresses {
    hidden: yes
    view_label: "Customers"
    type: count_distinct
    sql: ${customers.address};;
    value_format_name: decimal_0
    drill_fields: [transactions.drill_detail*]
  }

  measure: number_of_customers_per_address {
    view_label: "Customers"
    type: number
    sql: ${transactions.number_of_customers}/NULLIF(${number_of_addresses},0) ;;
    value_format_name: decimal_0
    drill_fields: [transactions.drill_detail*]
  }
}