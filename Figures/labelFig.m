function labelFig(xlab,ylab,tit,FontSize)

if ~isempty(xlab);xlabel(xlab,'Interpreter','latex','FontSize',FontSize);end
if ~isempty(ylab);ylabel(ylab,'Interpreter','latex','FontSize',FontSize);end
if ~isempty(tit);title(tit,'Interpreter','latex','FontSize',FontSize);end
