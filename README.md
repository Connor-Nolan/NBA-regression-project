# NBA-regression-project
Analysis and prediction of NBA game scores for the 2019-2020 NBA season.

Introduction:
	My Goal was to gather key statistics from NBA games and use them to predict the results of future games. In the NBA the better team wins a lot more often than not so I decided to try to beat the point spread set by Las Vegas instead of just predicting the winner.
Measures were collected each day from cleaningtheglass.com and entered into an excel spreadsheet, this site was chosen because it does not count long shots taken only because the game clock is expiring and discounts
"garbage time" stats where the winning team has a large lead and may sub in worse players or play worse than they otherwise would in order to rest their players. Point spreads were taken from Action Network. The csv file with the game data in this repository is up to date through the games played on March 11, 2020.


Method:
	The model's foundation is based on Dean Oliver's four factors, the idea takes into account the four things that can happen on any basketball possession: a shot, an offensive rebound, a turnover, or
a trip to the foul line.

In the first iteration of the model that I made in 2017 I would use the team's averages of these four factors to predict the scores. While this was somewhat effective it had some glaring lapses.
The major miss with this version was that it did not take into account the impact defenses would have on the inputs. When I am predicting the scores for games that have not happened yet in the current version I use a combination of the team's averages and the opposing team's defensive statistics relative to the league average.

Evaluation and Assumptions:

Evaluation of the models is something I do everytime I run them, which is usually every day there are NBA games being played. The images in this repository are one of the ways I evaluate the performance and check the linear regression assumptions. A few times I have found a mistake that I made while entering the data and have been able to correct them. Looking at the Q-Q plots for both models shows that our distribution is approximately normal which satisfies our normality assumption. The residual plots show that the residuals are pretty evenly spread throughout the plot which satisfies the homoscedasticity assumption. We also assume the scores of each game are independent of the other games. Our Cook's Distance plots show that we have a few points that have high leverage like the March 8th game between the Chicago Bulls and Brooklyn Nets. I have checked these games and the numbers are accurate they were just very strange basketball games. I could drop them from the dataset but I believe that weird things tend to happen in NBA games so I am going to leave them in. The R squared values of about .80 for both models suggest that the model is a good fit and also all input variables are shown to be statistically significant.

My performance on games where the two models gave one team an edge against Las Vegas was about 54% which may not sound terrific but is profitable in the long run. It is also important to keep in mind that the 54% number comes from predicting the games before they occur so the inputs are estimated.

Looking Forward: I have continued this NBA project with the start of the 2020-2021 season and have seen the model's predictions against the point spread have a 58.4% successful pick rate. It will be interesting to see if fans returning to more stadiums will impact the trends of the season so far.



