while {timer_kill_limit < timer_kill_base_value} do
{
	hint format ["Timer: %1", timer_kill_limit];
    timer_kill_limit = timer_kill_limit + 1;
	sleep 1;
};
