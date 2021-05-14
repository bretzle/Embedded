 library ieee;
 use ieee.std_logic_1164.all;
 
 entity HexToSeg7Decoder is
	port(
		ENABLE   : in std_logic;
		HEX_CODE : in std_logic_vector(3 downto 0);
		SEG_CODE : out std_logic_vector(7 downto 0)
	);
end entity HexToSeg7Decoder;

architecture dataflow of HexToSeg7Decoder is

	constant zero      : std_logic_vector(7 downto 0) := B"11000000"; 
	constant one       : std_logic_vector(7 downto 0) := B"11111001"; 
	constant two       : std_logic_vector(7 downto 0) := B"10100100";
	constant three     : std_logic_vector(7 downto 0) := B"10110000";
	constant four      : std_logic_vector(7 downto 0) := B"10011001"; 
	constant five      : std_logic_vector(7 downto 0) := B"10010010"; 
	constant six       : std_logic_vector(7 downto 0) := B"10000010"; 
	constant seven     : std_logic_vector(7 downto 0) := B"11011000"; 
	constant eight     : std_logic_vector(7 downto 0) := B"10000000"; 
	constant nine      : std_logic_vector(7 downto 0) := B"10011000"; 
	constant letterA   : std_logic_vector(7 downto 0) := B"10001000"; 
	constant letterB   : std_logic_vector(7 downto 0) := B"10000011"; 
	constant letterC   : std_logic_vector(7 downto 0) := B"10100111"; 
	constant letterD   : std_logic_vector(7 downto 0) := B"10100001"; 
	constant letterE   : std_logic_vector(7 downto 0) := B"10000110"; 
	constant letterF   : std_logic_vector(7 downto 0) := B"10001110"; 

	constant blank     : std_logic_vector(7 downto 0) := B"11111111";
	
	signal INTERNAL    : std_logic_vector(7 downto 0);
	
	
begin

		with HEX_CODE(3 downto 0) select
			INTERNAL <= zero    when B"0000",
				         one     when B"0001",
				         two     when B"0010",
				         three   when B"0011",
				         four    when B"0100",
				         five    when B"0101",
				         six     when B"0110",
				         seven   when B"0111",
				         eight   when B"1000",
				         nine    when B"1001",
				         letterA when B"1010",
				         letterB when B"1011",
				         letterC when B"1100",
				         letterD when B"1101",
				         letterE when B"1110",
				         letterF when others;
			
	with ENABLE select
		SEG_CODE <= INTERNAL when '1',
                  blank    when others;

end architecture dataflow;