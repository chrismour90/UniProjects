import numpy as np
import pandas as pd
import MySQLdb

from os.path import dirname, join

from bokeh.charts import Bar, Histogram
from bokeh.layouts import row, widgetbox, column
from bokeh.plotting import figure
from bokeh.layouts import layout, widgetbox
from bokeh.models import ColumnDataSource, Div, HoverTool, BoxSelectTool, Legend
from bokeh.models.widgets import Slider, Select, TextInput, RadioButtonGroup
from bokeh.palettes import Spectral5
from bokeh.io import curdoc


conn = MySQLdb.connect(host="localhost", user="root", passwd="aabbcc2435", db="icu") 
df = pd.read_sql_query('SELECT * FROM icu_trainingdata_final2', con=conn)
df['Height_m']=df['Height_cm']/100
df['BMI']=df['Admission_Weight_kg']/(df['Height_m']**2)
df=pd.DataFrame(df.loc[(df['BMI']<41)])
df=pd.DataFrame(df.loc[(df['Respiratory Rate (breaths per minute)']<100)])
df=pd.DataFrame(df.loc[(df['O2 saturation pulseoxymetry (%)']<101)])
df=pd.DataFrame(df.loc[(df['Arterial Blood Pressure mean (mmHg)']<250)])

SIZES = list(range(6, 22, 3))
COLORS = Spectral5
TOOLS = [BoxSelectTool(), HoverTool()]

# df=pd.read_csv('ICU_TRAININGDATA_final.csv')

columns=sorted(df.columns)

discrete = [x for x in columns if df[x].dtype == object]
continuous = [x for x in columns if x not in discrete]
quantileable = [x for x in continuous if len(df[x].unique()) > 20]

desc = Div(text=open(join(dirname(__file__), "description.html")).read(), width=800)

df2=pd.read_sql_query('SELECT AgeGroup, Mortality FROM icu_trainingdata_final2 WHERE Mortality = 1', con=conn)
bar1=Bar(df2, label='AgeGroup', values='Mortality', agg='count', title='Dead patients by Group Age', color='black')

df3=pd.read_sql_query('SELECT AgeGroup, Mortality  FROM icu_trainingdata_final2 WHERE Mortality =0', con=conn)
bar2=Bar(df3, label='AgeGroup', values='Mortality', agg='count', title='Alive patients by Group Age', color='red')

df4=pd.read_sql_query('SELECT Age FROM icu_trainingdata_final2', con=conn)
df4.ix[df4['Age']>299, 'Age']=90
hist=Histogram(df4, values='Age', color='navy', bins=10, title='Patients per age')

def create_figure():
	df1=pd.DataFrame(df.loc[(df[x.value]>0) & (df[y.value]>0)])
	legend="All patients"
	
	if radio_button_group.active==1:
		df1=pd.DataFrame(df1.loc[(df1['Mortality']==1)])
		legend="Dead patients"
	elif radio_button_group.active==2:
		df1=pd.DataFrame(df1.loc[(df1['Mortality']==0)])
		legend="Alive patients"

	if radio_button_mf_group.active==1:
		df1=pd.DataFrame(df1.loc[(df1['Gender']=='M')])
		legend="Male patients"
	elif radio_button_mf_group.active==2:
		df1=pd.DataFrame(df1.loc[(df1['Gender']=='F')])
		legend="Female patients"


	if radio_button_age_group.active==1:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP01')])
	elif radio_button_age_group.active==2:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP02')])
	elif radio_button_age_group.active==3:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP03')])
	elif radio_button_age_group.active==4:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP04')])
	elif radio_button_age_group.active==5:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP05')])
	elif radio_button_age_group.active==6:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP06')])
	elif radio_button_age_group.active==7:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP07')])
	elif radio_button_age_group.active==8:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP08')])
	elif radio_button_age_group.active==9:
		df1=pd.DataFrame(df1.loc[(df1['AgeGroup']=='GROUP09') ])

	xs = df1[x.value].values
	ys = df1[y.value].values
	x_title = x.value.title()
	y_title = y.value.title()

	kw = dict()
	if x.value in discrete:
		kw['x_range'] = sorted(set(xs))
	if y.value in discrete:
		kw['y_range'] = sorted(set(ys))
	kw['title'] = "%s vs %s" % (x_title, y_title)

	hover = HoverTool(tooltips=[(x.value, "$x"),(y.value, "$y")])

	p = figure(plot_height=600, plot_width=850, tools=[hover,'pan,wheel_zoom,box_zoom,reset,save'], **kw)
	p.xaxis.axis_label = x_title
	p.yaxis.axis_label = y_title

	sz = 8
	#if size.value != 'None':
	#	groups = pd.qcut(df1[size.value].values, len(SIZES))
	#	sz = [SIZES[xx] for xx in groups.codes]
	#	hover = HoverTool(tooltips=[(x.value, "$x"),(y.value, "$y"), (size.value, "@size.value"),])

	c = "#31AADE"

	if color.value != 'None':
		if color.value =='Dead (black) or Alive (red)':
			df1['color']=np.where(df1['Mortality']==1,'black','red')
			c=df1['color']
			legend="Dead (black) or Alive (red)"
		else:
			df1['color']=np.where(df1['Gender']=='M','blue','magenta')
			c=df1['color']
			legend="Men (blue) or Women (pink)"
	p.circle(x=xs, y=ys, color=c, size=sz, line_color="white", alpha=0.6, hover_color='white', hover_alpha=0.5, legend=legend)
	return p


def update(attr, old, new):
    r2.children[1] = create_figure()
	
x = Select(title='X-Axis', value='BMI', options=columns)
x.on_change('value', update)

y = Select(title='Y-Axis', value='Heart Rate (bpm)', options=columns)
y.on_change('value', update)

#size = Select(title='Size', value='None', options=['None'] +  quantileable)
#size.on_change('value', update)


color = Select(title='Colour', value='None', options=['None'] + ['Dead (black) or Alive (red)'] + ['Male (blue) or Female (pink)'])
color.on_change('value', update)

radio_button_group = RadioButtonGroup(labels=['All', 'Dead', 'Alive'], active=0)
radio_button_group.on_change('active', update)

radio_button_mf_group = RadioButtonGroup(labels=['All', 'Male', 'Female'], active=0)
radio_button_mf_group.on_change('active', update)

radio_button_age_group = RadioButtonGroup(labels=['All', '1: Age 10-19', '2: Age 20-29', '3: Age 30-39', '4: Age 40-49', '5: Age 50-59', '6: Age 60-69', '7: Age 70-79', '8: Age 80-89', '9: Age 89+'], active=0)
radio_button_age_group.on_change('active', update)


controls = widgetbox([x, y, color, radio_button_group, radio_button_mf_group, radio_button_age_group], width=370)
r1=row(desc)
r2=row(controls, create_figure())
r3=row(bar1,bar2)
r4=row(hist)
l = column(children=[r1,r2,r3,r4], sizing_mode='fixed')

curdoc().add_root(l)
curdoc().title = "ICU"


