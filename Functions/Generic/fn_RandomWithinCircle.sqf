
params ["_pos", "_range"];

if (_range > 0) then 
{
	_angle = random 360.0;
	_distance = random 1;
	_distance = sqrt _distance;
	_distance = _distance * _range;
	_vector = [[_distance], [0]];
	_rotMat = [[cos _angle, -(sin _angle)], [sin _angle, cos _angle]];
	_vector = _rotMat matrixMultiply _vector;
	_vector = matrixTranspose _vector;
	_vector = _vector select 0;
	
	_triggerPosX = (_pos select 0) + (_vector select 0);
	_triggerPosY = (_pos select 1) + (_vector select 1);
	
	[_triggerPosX, _triggerPosY, _pos select 2];
}
else
{
	_pos;
};
