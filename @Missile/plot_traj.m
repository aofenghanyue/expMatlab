function plot_traj(mis, tar)
    traj = mis.get_result();
    plot(traj(5,:),traj(6,:))
    hold on
    plot(tar.x,tar.y,'*')
    xlabel('x');ylabel('y');title('µØµ¿Õº')
end