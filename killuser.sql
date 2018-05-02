undef killsid
undef killserial
undef killinst

--ter system kill session '&killsid,&killserial' immediate;
alter system kill session '&killsid,&killserial,@&killinst' immediate;
