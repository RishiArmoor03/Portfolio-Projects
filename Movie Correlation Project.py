#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Import libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib
import matplotlib.pyplot  as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) #adjusts the configuration  of the plots we will create


# In[2]:


#Read in the data

df= pd.read_csv(r'C:\Users\rishi\OneDrive\Desktop\movies.csv')


# In[3]:


#Lets look at the data

df.head()


# In[6]:


#lets see if there is any missing data
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,pct_missing))


# In[7]:


#Extracting the missing data

df = df.dropna()
df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)


# In[8]:


#data typer for columns

df.dtypes


# In[9]:


#changing data types

df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[10]:


df


# In[11]:


df['released'] = df['released'].astype(str).str[:13]
df


# In[23]:


df = df.sort_values(['gross'], inplace = False, ascending = False)


# In[16]:


pd.set_option('display.max_rows', None)


# In[21]:


#drop if there is any duplicates

df.drop_duplicates()


# In[ ]:


#budget high correlation
#budget high correlation


# In[25]:


#scatter plot with buget vs gross

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Gross Earnings')

plt.ylabel('Budget for Firm')

plt.show()


# In[46]:


df.head()


# In[32]:


#plot the budget vs gross using seaborn

sns.regplot(x=df['budget'], y=df['gross'], scatter_kws={"color":"red"}, line_kws={"color":"blue"})


# In[34]:


#lets start looking at the correlation

df.corr(method = 'pearson') #pearson, kendall, spearman


# In[40]:


#High correlation between budget and gross

correlation_matrix = df.corr(method = 'pearson')

sns.heatmap(correlation_matrix, annot = True)

plt.title('Correlation Matric for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[47]:


#looks at company

df1 = df
for col_name in df1.columns:
    if(df1[col_name].dtype == 'object'):
        df1[col_name] = df1[col_name].astype('category')
        df1[col_name] = df1[col_name].cat.codes
df1


# In[48]:


correlation_matrix = df1.corr(method = 'pearson')

sns.heatmap(correlation_matrix, annot = True)

plt.title('Correlation Matric for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Movie Features')

plt.show()


# In[49]:


df1.corr()


# In[50]:


correlation_mat = df1.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[51]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[52]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:


#gross and votes have the highest correlation to gross earnings

#company has low correlation

