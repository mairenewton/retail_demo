view: channels {
  sql_table_name: retail.channels ;;

  dimension: id {
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }
}
