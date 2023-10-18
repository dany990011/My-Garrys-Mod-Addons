// Created by Crowbar 0.74

$modelname "rat_king\rat_king.mdl"

$bodygroup "studio"
{
	studio "Rat_reference.smd"
}


$surfaceprop "flesh"

$contents "solid"

$illumposition 0 6.683 4.919

$cdmaterials "models\rat\"

$cbox 0 0 0 0 0 0

$bbox -24.523 -3.988 0 11.157 3.988 9.839

$hboxset "default"
$hbox 0 "rat.hips" -4 -4.5 -3.75 4 2.5 3.75
$hbox 0 "rat.spine" -2.79 -4 -3 2.79 2 3
$hbox 0 "rat.head" -0.96 -2.75 -2.25 5.03 1.75 2.25
$hbox 0 "rat.tail1" 0 -1.25 -1.2 12 1.25 1.8

$definebone "rat.hips" "" 0 4.487925 7.219572 0 89.999982 89.999982 0 0 0 0 0 0
$definebone "rat.spine" "rat.hips" -6.24552 0.306979 0 0 -179.999978 179.999978 0 0 0 0 0 0
$definebone "rat.head" "rat.spine" 4.128282 -0.354312 0 0 0 0 0 0 0 0 0 0
$definebone "rat.arm_L_humerus" "rat.spine" 1.476702 -1.942044 -1.630675 10.085203 -119.298297 174.560074 0 0 0 0 0 0
$definebone "rat.arm_L_radius" "rat.arm_L_humerus" 2.895893 0 0 0 -65.066062 -0.000001 0 0 0 0 0 0
$definebone "rat.arm_r_humerus" "rat.spine" 1.476702 -1.94204 1.630675 -10.085203 -119.298297 5.439948 0 0 0 0 0 0
$definebone "rat.arm_r_radius" "rat.arm_r_humerus" 2.895894 0 0 0 65.066062 0 0 0 0 0 0 0
$definebone "rat.femur_L" "rat.hips" 0.77097 -1.378489 2.042785 -13.518365 -95.772475 1.353785 0 0 0 0 0 0
$definebone "rat.tibia_L" "rat.femur_L" 2.909593 0 0 0 55.871979 -0.000003 0 0 0 0 0 0
$definebone "rat.tarsus_L" "rat.tibia_L" 3.017056 0 0 -0.000003 -110.131664 0.000004 0 0 0 0 0 0
$definebone "rat.femur_r" "rat.hips" 0.77097 -1.378489 -2.042785 13.518365 -95.77253 178.646234 0 0 0 0 0 0
$definebone "rat.tibia_r" "rat.femur_r" 2.909593 0 0 -0.000003 -55.871969 0.000005 0 0 0 0 0 0
$definebone "rat.tarsus_r" "rat.tibia_r" 3.017056 0 0 -0.000003 110.131657 -0.000004 0 0 0 0 0 0
$definebone "rat.tail1" "rat.hips" 3.069408 -1.178342 0 0 -20.411566 89.999982 0 0 0 0 0 0
$definebone "rat.tail2" "rat.tail1" 6.026319 0 0 1.756976 0 0 0 0 0 0 0 0
$definebone "rat.tail3" "rat.tail2" 6.031434 0 0 4.277823 0 0 0 0 0 0 0 0


$sequence "idle" {
	"anims\Rat_reference_skeleton.001Action.smd"
	activity "ACT_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "run" {
	"anims\Rat_reference_skeleton.001Action.smd"
	activity "ACT_RUN" 1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
	walkframe 6 LX LY
}



$collisionjoints "rat_physics.smd"
{
	$mass 2
	$inertia 10
	$damping 0.01
	$rotdamping 1
	$rootbone "rat.hips"


	$jointconstrain "rat.tail1" x limit 0 0 1
	$jointconstrain "rat.tail1" y limit -28 30 1
	$jointconstrain "rat.tail1" z limit -41 41 1

	$jointconstrain "rat.tail2" x limit 0 0 0
	$jointconstrain "rat.tail2" y limit -32 37 1
	$jointconstrain "rat.tail2" z limit -35 35 1

	$jointconstrain "rat.spine" x limit 0 0 0
	$jointconstrain "rat.spine" y limit -35 35 1
	$jointconstrain "rat.spine" z limit -30 28 1

	$jointconstrain "rat.head" x limit 0 0 0
	$jointconstrain "rat.head" y limit -48 48 1
	$jointconstrain "rat.head" z limit -59 30 1

	$jointconstrain "rat.tail3" x limit 0 0 0
	$jointconstrain "rat.tail3" y limit -32 32 1
	$jointconstrain "rat.tail3" z limit -30 30 1
}
