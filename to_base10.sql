create or replace function to_base10 ( p_number IN varchar2, p_base IN number) return NUMBER
as
	len	number;
	pos	number := 0;
	idx	number;
	base10	number := 0;
	ch  	char;
begin
	len := length(p_number);
	for pos in 1..len
	loop
		ch := substr(p_number,pos,1);
		idx := instr('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ', ch) - 1;

		-- =========================================
		--  Need check here to see if idx > p_base.
		--  If so, raise error.
		-- =========================================
		base10 := base10 + (idx * power(p_base,(len-pos)) );
	end loop;

	return(base10);
end;
/


select to_base10 (   '12', 8) from dual;
select to_base10 (   '13', 8) from dual;

select to_base10 (   '12', 16) from dual;

select to_base10 (   '2S', 36) from dual;
select to_base10 (   'RS', 36) from dual;
select to_base10 (  '7PS', 36) from dual;
select to_base10 ( '255S', 36) from dual;
select to_base10 (    '1', 36) from dual;
select to_base10 (   '10', 36) from dual;
select to_base10 (  '100', 36) from dual;
select to_base10 ( '1000', 36) from dual;

--select regcode from phase2.person_regcode where person_regcode_key = 1198573;
select to_base10 ( '3056387443998', 36) from dual;

drop function to_base10 ;
