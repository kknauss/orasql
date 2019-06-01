 begin
    for i in ( 

        select index_owner, index_name, partition_name, 'partition' ddl_type
        from all_ind_partitions
        where (index_owner,index_name) in 
           ( select owner, index_name
             from   all_indexes
             where table_owner = upper(p_owner)
             and   table_name  = upper(p_table_name)
           )
        and status = 'UNUSABLE'

        union all

        select index_owner, index_name, subpartition_name, 'subpartition' ddl_type
        from all_ind_subpartitions
        where (index_owner,index_name) in 
           ( select owner, index_name
             from   all_indexes
             where table_owner = upper(p_owner)
             and   table_name  = upper(p_table_name)
           )
        and status = 'UNUSABLE'

        union all

        select owner, index_name, null, null
        from all_indexes
        where table_owner = upper(p_owner)
        and   table_name  = upper(p_table_name)
        and status = 'UNUSABLE'
    )
    loop
      if i.ddl_type is null then
        ddl('alter index '||i.index_owner||'.'||i.index_name||' rebuild');
      else
        ddl('alter index '||i.index_owner||'.'||i.index_name||' rebuild '||i.ddl_type||' '||i.partition_name);
      end if;
    end loop;
  end;
