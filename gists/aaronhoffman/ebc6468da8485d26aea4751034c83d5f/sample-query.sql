-- sample query of the OpmFedScope database

select
 f.AGYSUB AgencyCode
,ag.AGYTshort AgencyName
,f.LOC LocationCode
,l.LOCTshort LocationName
,f.AGELVL AgeCode
,a.AGELVLT AgeRange
,ed.EDLVLTYPTshort EducationLevel
,f.LOS LengthOfService
,los.LOSLVLT ServiceRange
,oc.OCCTshort
,f.PPGRD PayGrade
,sal.SALLVLT SalaryRange
,f.SALARY Salary

from
dbo.FACTDATA f
left join dbo.DTagy ag on (f.AGYSUB = ag.AGYSUB)
left join dbo.DTloc l on (f.LOC = l.LOC)
left join dbo.DTagelvl a on (f.AGELVL = a.AGELVL)
left join dbo.DTedlvl ed on (f.EDLVL = ed.EDLVL)
left join dbo.DTloslvl los on (f.LOSLVL = los.LOSLVL)
left join dbo.DTocc oc on (f.OCC = oc.OCC)
left join dbo.DTpatco p on (f.PATCO = p.PATCO)
left join dbo.DTppgrd gr on (f.PPGRD = gr.PPGRD) 
left join dbo.DTsallvl sal on (f.SALLVL = sal.SALLVL)
left join dbo.DTstemocc stm on (f.STEMOCC = stm.STEMOCC)
left join dbo.DTsuper sup on (f.SUPERVIS = sup.SUPERVIS)
